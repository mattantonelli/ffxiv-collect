namespace :shops do
  namespace :sources do
    desc 'Create shop sources'
    task update: :environment do
      include ActionView::Helpers::NumberHelper

      purchase_type = SourceType.find_by(name: 'Purchase')

      puts 'Creating GilShop sources'
      item_ids = XIVData.sheet('GilShopItem', raw: true).map do |entry|
        entry['Item']
      end

      Item.where.not(unlock_id: nil).where.not(price: 0).where(id: item_ids).each do |item|
        unlock = item.unlock
        text = "#{number_with_delimiter(item.price)} Gil"
        create_shop_source(unlock, purchase_type, text)
      end

      puts 'Creating SpecialShop sources'
      item_ids = Item.where.not(unlock_id: nil).pluck(:id).map(&:to_s)

      XIVData.sheet('SpecialShop', raw: true).each do |shop|
        2.times do |j|
          60.times do |i|
            item_id = shop["Item{Receive}[#{i}][#{j}]"]
            break if item_id == '0'
            next unless item_ids.include?(item_id)

            price = shop["Count{Cost}[#{i}][#{j}]"]
            next if price == '0'

            unlock = Item.find(item_id).unlock
            currency = Item.find(shop["Item{Cost}[#{i}][#{j}]"])
            text = "#{number_with_delimiter(price)} #{price == '1' ? currency.name_en : currency.plural_en}"

            # Do not create shop sources for Moogle Treasure Trove rewards
            unless text.match?('Irregular Tomestones')
              create_shop_source(unlock, purchase_type, text)
            end
          end
        end
      end

      puts 'Creating Grand Company sources'
      XIVData.sheet('GCScripShopItem', raw: true).each do |entry|
        next unless item_ids.include?(entry['Item'])

        unlock = Item.find(entry['Item']).unlock
        price = entry['Cost{GCSeals}']
        text = "#{number_with_delimiter(price)} Company Seals"
        create_shop_source(unlock, purchase_type, text)
      end
    end
  end
end

# Create shop sources for collectables with no known sources.
# In the event of Orchestrion rolls, set the details.
def create_shop_source(unlock, type, text)
  if unlock.class == Orchestrion
    unless unlock.details.present?
      unlock.update(details: text)
    end
  else
    unless unlock.sources.any?
      unlock.sources.create!(type: type, text: text)
    end
  end
end

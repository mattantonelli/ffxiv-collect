namespace 'sources:shops' do
  desc 'Create shop sources'
  task update: :environment do
    PaperTrail.enabled = false

    include ActionView::Helpers::NumberHelper

    fate_type = SourceType.find_by(name_en: 'FATE')
    gold_saucer_type = SourceType.find_by(name_en: 'Gold Saucer')
    hunts_type = SourceType.find_by(name_en: 'Hunts')
    island_sanctuary_type = SourceType.find_by(name_en: 'Island Sanctuary')
    purchase_type = SourceType.find_by(name_en: 'Purchase')
    pvp_type = SourceType.find_by(name_en: 'PvP')
    skybuilders_type = SourceType.find_by(name_en: 'Skybuilders')
    vc_dungeon_type = SourceType.find_by(name_en: 'V&C Dungeon')
    wondrous_tails_type = SourceType.find_by(name_en: 'Wondrous Tails')

    # Set up Outfits to map item_id's to outfits and keep a running total
    item_outfits = OutfitItem.all.each_with_object({}) do |outfit_item, h|
      h[outfit_item.item_id.to_s] = outfit_item.outfit_id.to_s
    end

    outfit_item_ids = item_outfits.keys
    outfits = Hash.new { |h, k| h[k] = { price: 0 } }

    puts 'Creating GilShop sources'
    item_ids = XIVData.sheet('GilShopItem', raw: true).map do |entry|
      entry['Item']
    end

    gil = Item.find_by(name_en: 'Gil')

    Item.where.not(unlock_id: nil).where.not(price: 0).where(id: item_ids).each do |item|
      texts = currency_texts(item.price, gil)
      create_shop_source(item.unlock, purchase_type, texts)
    end

    puts 'Creating SpecialShop sources'
    item_ids = Item.where.not(unlock_id: nil).pluck(:id).map(&:to_s)

    XIVData.sheet('SpecialShop', raw: true).each do |shop|
      2.times do |j|
        60.times do |i|
          item_id = shop["Item{Receive}[#{i}][#{j}]"]
          break if item_id == '0'

          next unless item_ids.include?(item_id) || outfit_item_ids.include?(item_id)

          price = shop["Count{Cost}[#{i}][#{j}]"]
          next if price == '0'

          currency = shop["Item{Cost}[#{i}][#{j}]"]
          case currency.to_i
          when 25, 36656
            type = pvp_type
          when 27, 10307, 26533
            type = hunts_type
          when 29, 41629
            type = gold_saucer_type
          when 26807
            type = fate_type
          when 28063
            type = skybuilders_type
          when 30341
            type = wondrous_tails_type
          when 37549
            type = island_sanctuary_type
          when 39884, 41078
            type = vc_dungeon_type
          else
            type = purchase_type
          end

          currency = Item.find(shop["Item{Cost}[#{i}][#{j}]"])

          # Do not create shop sources for Moogle Treasure Trove rewards
          next if currency['name_en'].match?('Irregular Tomestone')

          # Create collectable source
          if item_ids.include?(item_id)
            texts = currency_texts(price, currency)
            create_shop_source(Item.find(item_id).unlock, type, texts)
          end

          # Add outfit source data
          if outfit_item_ids.include?(item_id)
            outfit = outfits[item_outfits[item_id]]

            outfit[:price] += price.to_i
            outfit[:currency] ||= currency
            outfit[:type] = type
          end
        end
      end
    end

    # Create outfit sources based on the final data
    outfits.each do |id, outfit|
      texts = currency_texts(outfit[:price], outfit[:currency])
      create_shop_source(Outfit.find(id), outfit[:type], texts)
    end

    puts 'Creating Grand Company sources'
    XIVData.sheet('GCScripShopItem', raw: true).each do |entry|
      next unless item_ids.include?(entry['Item'])

      unlock = Item.find(entry['Item']).unlock

      texts = %w(en de fr ja).each_with_object({}) do |locale, h|
        amount = number_with_delimiter(entry['Cost{GCSeals}'], locale: locale)
        h["text_#{locale}"] = I18n.t('sources.seals', amount: amount, locale: locale)
      end

      create_shop_source(unlock, purchase_type, texts)
    end
  end
end

private
# Create shop sources for collectables with no known sources.
# In the event of Orchestrion rolls, set the details.
def create_shop_source(unlock, type, texts)
  unless unlock.sources.any?
    unlock.sources.create!(**texts, type: type)
  end
end

def currency_texts(price, currency)
  %w(en de fr ja).each_with_object({}) do |locale, h|
    h["text_#{locale}"] = "#{number_with_delimiter(price, locale: locale)} " \
      "#{price == '1' ? currency["name_#{locale}"] : currency["plural_#{locale}"]}"
  end
end

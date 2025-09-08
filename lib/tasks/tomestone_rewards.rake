namespace :tomestones do
  desc 'Create Philosophy tomestone rewards from CSV data'
  namespace :philosophy do
    task create: :environment do
      create_rewards('philosophy')
    end
  end

  desc 'Create Mythology tomestone rewards from CSV data'
  namespace :mythology do
    task create: :environment do
      create_rewards('mythology')
    end
  end

  desc 'Create Soldiery tomestone rewards from CSV data'
  namespace :soldiery do
    task create: :environment do
      create_rewards('soldiery')
    end
  end

  desc 'Create Law tomestone rewards from CSV data'
  namespace :law do
    task create: :environment do
      create_rewards('law')
    end
  end

  desc 'Create Esoterics tomestone rewards from CSV data'
  namespace :esoterics do
    task create: :environment do
      create_rewards('esoterics')
    end
  end

  desc 'Create Pageantry tomestone rewards from CSV data'
  namespace :pageantry do
    task create: :environment do
      create_rewards('pageantry')
    end
  end

  # Clean up changed icon IDs on item rewards
  namespace :images do
    task create: :environment do
      TomestoneReward.where(collectable_type: 'Item').each do |reward|
        item = reward.collectable
        create_image(item.id, XIVData.image_path(item.icon_id),
                     Rails.root.join('app/assets/images/items', "#{item.icon_id}.png"))
      end
    end
  end

  desc 'Create the latest tomestone rewards from SpecialShop data'
  namespace :latest do
    task create: :environment do
      puts 'Creating tomestone rewards'
      count = TomestoneReward.count

      XIVData.sheet('SpecialShop').each do |shop|
        next unless shop['Name'] == 'Newest Irregular Tomestone Exchange'


        60.times do |i|
          item_id = shop["Item[#{i}].Item[0]"]
          break if item_id == '0'

          item = Item.find(item_id)
          collectable = item.unlock
          cost = shop["Item[#{i}].CurrencyCost[0]"]

          tomestone = Item.find(shop["Item[#{i}].ItemCost[0]"]).tomestone_name

          TomestoneReward.find_or_create_by!(collectable: collectable || item, cost: cost, tomestone: tomestone)

          unless collectable.present?
            create_image(item.id, XIVData.image_path(item.icon_id), 'items')
          end
        end
      end

      puts "Created #{TomestoneReward.count - count} new tomestone rewards"
    end
  end
end

def create_rewards(tomestone)
  CSV.foreach(Rails.root.join("vendor/#{tomestone}.csv"), headers: true, header_converters: :symbol) do |row|
    collectable = row[:type].constantize.find_by(name_en: row[:name])
    TomestoneReward.find_or_create_by!(collectable: collectable, cost: row[:cost], tomestone: tomestone.capitalize)

    if row[:type] == 'Item'
      item = Item.find_by(name_en: row[:name])
      create_image(item.id, XIVData.image_path(item.icon_id),
                   Rails.root.join('app/assets/images/items', "#{item.icon_id}.png"))
    end
  end
end

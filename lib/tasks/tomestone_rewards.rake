namespace :tomestones do
  desc 'Create Mythology tomestone rewards from CSV data'
  namespace :mythology do
    task create: :environment do
      CSV.foreach(Rails.root.join('vendor/mythology.csv'), headers: true, header_converters: :symbol) do |row|
        collectable = row[:type].constantize.find_by(name_en: row[:name])
        TomestoneReward.find_or_create_by!(collectable: collectable, cost: row[:cost], tomestone: 'Mythology')
      end
    end
  end

  desc 'Create Soldiery tomestone rewards from CSV data'
  namespace :soldiery do
    task create: :environment do
      CSV.foreach(Rails.root.join('vendor/soldiery.csv'), headers: true, header_converters: :symbol) do |row|
        collectable = row[:type].constantize.find_by(name_en: row[:name])
        TomestoneReward.find_or_create_by!(collectable: collectable, cost: row[:cost], tomestone: 'Soldiery')
      end
    end
  end

  desc 'Create Law tomestone rewards from CSV data'
  namespace :law do
    task create: :environment do
      CSV.foreach(Rails.root.join('vendor/law.csv'), headers: true, header_converters: :symbol) do |row|
        collectable = row[:type].constantize.find_by(name_en: row[:name])
        TomestoneReward.find_or_create_by!(collectable: collectable, cost: row[:cost], tomestone: 'Law')
      end
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

  desc 'Create the latest tomestone rewards from SpecialShop data'
  namespace :latest do
    task create: :environment do
      puts 'Creating tomestone rewards'
      count = TomestoneReward.count

      XIVData.sheet('SpecialShop', raw: true).each do |shop|
        next unless shop['Name'] == 'Newest Irregular Tomestone Exchange'

        tomestone = Item.find(shop['Item{Cost}[0][0]']).name_en.split(' ').last

        60.times do |i|
          item_id = shop["Item{Receive}[#{i}][0]"]
          break if item_id == '0'

          item = Item.find(item_id)
          collectable = item.unlock
          cost = shop["Count{Cost}[#{i}][0]"]

          TomestoneReward.find_or_create_by!(collectable: collectable || item, cost: cost, tomestone: tomestone)

          unless collectable.present?
            create_image(item.id, XIVData.icon_path(item.icon_id),
                         Rails.root.join('app/assets/images/items', "#{item.icon_id}.png"))
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
      create_image(item.id, XIVData.icon_path(item.icon_id),
                   Rails.root.join('app/assets/images/items', "#{item.icon_id}.png"))
    end
  end
end

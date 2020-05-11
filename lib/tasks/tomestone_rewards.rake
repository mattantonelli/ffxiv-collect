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
end

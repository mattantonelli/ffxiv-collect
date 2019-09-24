namespace :tomestone_rewards do
  desc 'Create tomestone rewards from CSV data'
  task create: :environment do
    CSV.foreach(Rails.root.join('vendor/mythology.csv'), headers: true, header_converters: :symbol) do |row|
      collectable = row[:type].constantize.find_by(name_en: row[:name])
      TomestoneReward.find_or_create_by!(collectable: collectable, cost: row[:cost])
    end
  end
end

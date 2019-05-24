namespace :characters do
  desc 'Synchronize all verified characters'
  task sync_verified: :environment do
    puts "[#{Time.now.utc}] Synchronizing verified characters..."
    characters = Character.where.not(verified_user: nil).where('last_parsed < ?', Time.now - 5.hours).order(:name)

    if characters.present?
      Character.sync(characters.pluck(:id))
      count = characters.size
      puts "[#{Time.now.utc}] #{count} verified #{'character'.pluralize(count)} synchronized.\n\n"
    else
      puts "No stale verified characters.\n\n"
    end
  end

  desc 'Synchronize all unverified characters'
  task sync_unverified: :environment do
    puts "[#{Time.now.utc}] Synchronizing unverified characters..."
    characters = Character.where(verified_user: nil).where('last_parsed < ?', Time.now - 5.hours).order(:name)

    if characters.present?
      Character.sync(characters.pluck(:id))
      count = characters.size
      puts "[#{Time.now.utc}] #{count} unverified #{'character'.pluralize(count)} synchronized.\n\n"
    else
      puts "No stale unverified characters.\n\n"
    end
  end
end

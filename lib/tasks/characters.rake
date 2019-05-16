namespace :characters do
  desc 'Synchronize all user-linked characters'
  task sync: :environment do
    puts "[#{Time.now.utc}] Checking for stale characters..."
    stale_characters = Character.where('last_parsed < ?', Time.now - 5.hours)

    stale_characters.each do |character|
      puts "  Updating: #{character.name} (#{character.server}) - Last updated: #{character.last_parsed}"
    end

    if stale_characters.present?
      Character.sync(stale_characters.pluck(:id))
      count = stale_characters.size
      puts "[#{Time.now.utc}] #{count} #{'character'.pluralize(count)} checked.\n\n"
    else
      puts "No stale characters.\n\n"
    end
  end
end

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
      puts "[#{Time.now.utc}] Updates complete.\n\n"
    else
      puts "No updates required.\n\n"
    end
  end
end

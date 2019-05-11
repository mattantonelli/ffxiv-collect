namespace :characters do
  desc 'Synchronize all user-linked characters'
  task sync: :environment do
    puts "[#{Time.now}] Checking for stale characters..."
    stale_characters = Character.where(id: User.pluck(:character_id)).where('last_parsed < ?', Time.now - 6.hours)

    stale_characters.each do |character|
      puts "  Updating: #{character.name} (#{character.server}) - Last updated: #{character.last_parsed}"
    end

    Character.sync(stale_characters.pluck(:id))

    if stale_characters.present?
      puts "[#{Time.now}] Updates complete.\n\n"
    else
      puts "No updates required.\n\n"
    end
  end
end

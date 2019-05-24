namespace :characters do
  namespace :verified do
    desc 'Synchronize all verified characters'
    task sync: :environment do
      characters = Character.where.not(verified_user: nil).where('last_parsed < ?', Time.now - 5.hours).order(:name)
      sync(characters, 'verified')
    end
  end

  namespace :unverified do
    desc 'Synchronize all unverified characters'
    task sync: :environment do
      characters = Character.where(verified_user: nil).where('last_parsed < ?', Time.now - 5.hours).order(:name)
      sync(characters, 'unverified')
    end
  end
end

def sync(characters, status)
  puts "[#{Time.now.utc}] Synchronizing #{status} characters..."

  if characters.present?
    characters.each_slice(500) do |slice|
      Character.sync(slice.pluck(:id))
    end

    count = characters.size
    puts "[#{Time.now.utc}] #{count} #{status} #{'character'.pluralize(count)} synchronized.\n\n"
  else
    puts "[#{Time.now.utc}] No stale #{status} characters.\n\n"
  end
end

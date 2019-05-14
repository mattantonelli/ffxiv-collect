BARDING_COLUMNS = %w(ID Name_* IconBody IconHead).freeze

namespace :bardings do
  desc 'Create the bardings'
  task create: :environment do
    puts 'Creating bardings'

    count = Barding.count
    XIVAPI_CLIENT.content(name: 'BuddyEquip', columns: BARDING_COLUMNS, limit: 1000).each do |barding|
      next unless barding.name_en.present?

      data = { id: barding.id, patch: 'N/A' }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(barding["name_#{locale}"])
      end

      image_url = barding.icon_body.present? ? barding.icon_body : barding.icon_head
      download_image(barding.id, image_url, 'bardings')

      if existing = Barding.find_by(id: barding.id)
        data = without_names(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Barding.create!(data)
      end
    end

    create_spritesheet(Barding, 'bardings', 'bardings.png', 40, 40)

    puts "Created #{Barding.count - count} new bardings"
  end
end

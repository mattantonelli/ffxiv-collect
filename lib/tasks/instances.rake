INSTANCE_COLUMNS = %w(ID Name_* ContentType.Name_en).freeze

namespace :instances do
  desc 'Create the instances'
  task create: :environment do
    puts 'Creating instances'

    count = Instance.count
    XIVAPI_CLIENT.content(name: 'InstanceContent', columns: INSTANCE_COLUMNS, limit: 1000).each do |instance|
      content_type = instance.content_type.name_en&.singularize
      next unless instance.name_en.present? && Instance.valid_types.include?(content_type)

      data = { id: instance.id, content_type: content_type }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(instance["name_#{locale}"])
      end

      Instance.find_or_create_by!(data)
    end

    puts "Created #{Instance.count - count} new instances"
  end
end

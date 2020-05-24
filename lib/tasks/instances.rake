INSTANCE_COLUMNS = %w(Content Name_* ContentType.Name_en).freeze

namespace :instances do
  desc 'Create the instances'
  task create: :environment do
    puts 'Creating instances'

    count = Instance.count
    XIVAPI_CLIENT.content(name: 'ContentFinderCondition', columns: INSTANCE_COLUMNS, limit: 1000).each do |instance|
      content_type = instance.content_type.name_en&.singularize
      next if instance.name_en.blank? || !Instance.valid_types.include?(content_type)

      data = { id: instance.content, content_type: content_type }

      %w(en de fr ja).each do |locale|
        name = instance["name_#{locale}"]
        data["name_#{locale}"] = sanitize_name(name)
      end

      if existing = Instance.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Instance.find_or_create_by!(data) unless data['name_en'].blank?
      end
    end

    puts "Created #{Instance.count - count} new instances"
  end
end

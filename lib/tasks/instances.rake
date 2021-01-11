namespace :instances do
  desc 'Create the instances'
  task create: :environment do
    puts 'Creating instances'

    count = Instance.count
    instances = XIVData.sheet('ContentFinderCondition', locale: 'en').each_with_object({}) do |instance, h|
      next unless instance['Name'].present? && Instance.valid_types.include?(instance['ContentType'].singularize)

        # Use the Content ID as the Instance ID so we can sync with the ID used by the DB sites
        h[instance['#']] = { id: XIVData.related_id(instance['Content']),
                             content_type: instance['ContentType'],
                             name_en: sanitize_name(instance['Name']) }
    end

    %w(de fr ja).each do |locale|
      XIVData.sheet('ContentFinderCondition', locale: locale).each do |instance|
        next unless instances.has_key?(instance['#'])
        instances[instance['#']]["name_#{locale}"] = sanitize_name(instance['Name'])
      end
    end

    instances.values.each do |instance|
      if existing = Instance.find_by(id: instance[:id])
        existing.update!(instance) if updated?(existing, instance)
      else
        Instance.find_or_create_by!(instance)
      end
    end

    puts "Created #{Instance.count - count} new instances"
  end
end

namespace :minions do
  desc 'Create the minions'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating minions'

    behaviors = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('CompanionMove', locale: locale).each do |behavior|
        next unless behavior['Name'].present?

        data = h[behavior['#']] || { id: behavior['#'] }
        data["name_#{locale}"] = behavior ['Name']
        h[data[:id]] = data
      end
    end

    behaviors.values.each do |behavior|
      MinionBehavior.find_or_create_by!(behavior)
    end

    races = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('MinionRace', locale: locale).each do |race|
        next unless race['Name'].present?

        data = h[race['#']] || { id: race['#'] }
        data["name_#{locale}"] = race ['Name']
        h[data[:id]] = data
      end
    end

    races.values.each do |race|
      MinionRace.find_or_create_by!(race)
    end

    skill_types = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('MinionSkillType', locale: locale).each do |type|
        next unless type['Name'].present?

        data = h[type['#']] || { id: type['#'] }
        data["name_#{locale}"] = type ['Name']
        h[data[:id]] = data
      end
    end

    skill_types.values.each do |type|
      MinionSkillType.find_or_create_by!(type)
    end

    count = Minion.count
    minions = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Companion', locale: locale).each do |minion|
        next if minion['Order'] == '0'

        data = h[minion['#']] || { id: minion['#'], order: minion['Order'], hp: minion['HP'], cost: minion['Cost'],
                                   skill_angle: minion['Skill{Angle}'], skill_cost: minion['Skill{Cost}'], icon: minion['Icon'],
                                   behavior_id: MinionBehavior.find_by(name_en: minion['Behavior']).id.to_s,
                                   race_id: MinionRace.find_by(name_en: minion['MinionRace']).id.to_s}

        data["name_#{locale}"] = sanitize_name(minion['Singular'])
        h[data[:id]] = data
      end
    end

    # Add the remaining data from the transient sheet
    %w(en de fr ja).each do |locale, h|
      XIVData.sheet('CompanionTransient', locale: locale).each do |minion|
        next unless minions.has_key?(minion['#'])

        data = minions[minion['#']]
        data.merge!("description_#{locale}" => sanitize_text(minion['Description']),
                    "enhanced_description_#{locale}" => sanitize_text(minion['Description{Enhanced}']),
                    "tooltip_#{locale}" => sanitize_text(minion['Tooltip']),
                    "skill_#{locale}" => sanitize_name(minion['SpecialAction{Name}']),
                    "skill_description_#{locale}" => sanitize_text(minion['SpecialAction{Description}']),
                    attack: minion['Attack'], defense: minion['Defense'], speed: minion['Speed'],
                    area_attack: minion['HasAreaAttack'] == 'True', gate: minion['Strength{Gate}'] == 'True',
                    eye: minion['Strength{Eye}'] == 'True', shield: minion['Strength{Shield}'] == 'True',
                    arcana: minion['Strength{Arcana}'] == 'True')

        if locale == 'en'
          data[:skill_type_id] ||= MinionSkillType.find_by(name_en: minion['MinionSkillType'])&.id&.to_s
        end
      end
    end

    minions.values.each do |minion|
      large_icon = minion[:icon].gsub('/004', '/068')
      icon_id = minion[:icon].sub(/.*?(\d+)\.tex/, '\1').to_i
      footprint_icon = XIVData.icon_path(65000 + icon_id)

      create_image(minion[:id], large_icon, 'minions/large')
      create_image(minion[:id], minion.delete(:icon), 'minions/small')
      create_image(minion[:id], footprint_icon, 'minions/footprint', '#151515ff')

      if existing = Minion.find_by(id: minion[:id])
        existing.update!(minion) if updated?(existing, minion)
      else
        Minion.create!(minion)
      end
    end

    create_spritesheet('minions/small')

    puts "Created #{Minion.count - count} new minions"
  end
end

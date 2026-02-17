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
                                   skill_angle: minion['SkillAngle'], skill_cost: minion['SkillCost'],
                                   icon: XIVData.format_icon_id(minion['Icon']),
                                   behavior_id: minion['Behavior'], race_id:  minion['MinionRace'] }

        data["name_#{locale}"] = sanitize_name(minion['Singular'], locale: locale, capitalize: true)
        h[data[:id]] = data
      end
    end

    # Add the remaining data from the transient sheet
    %w(en de fr ja).each do |locale, h|
      XIVData.sheet('CompanionTransient', locale: locale).each do |minion|
        next unless minions.has_key?(minion['#'])

        data = minions[minion['#']]
        data.merge!("description_#{locale}" => sanitize_text(minion['Description']),
                    "enhanced_description_#{locale}" => sanitize_text(minion['DescriptionEnhanced']),
                    "tooltip_#{locale}" => sanitize_text(minion['Tooltip']),
                    "skill_#{locale}" => sanitize_name(minion['SpecialActionName'], locale: locale),
                    "skill_description_#{locale}" => sanitize_text(minion['SpecialActionDescription'], preserve_space: true),
                    attack: minion['Attack'], defense: minion['Defense'], speed: minion['Speed'],
                    area_attack: minion['HasAreaAttack'] == 'True', gate: minion['StrengthGate'] == 'True',
                    eye: minion['StrengthEye'] == 'True', shield: minion['StrengthShield'] == 'True',
                    arcana: minion['StrengthArcana'] == 'True', skill_type_id: minion['MinionSkillType'])
      end
    end

    minions.values.each do |minion|
      large_icon = minion[:icon].sub(/^004/, '068')
      footprint_icon = 65000 + minion[:icon].to_i

      create_image(minion[:id], XIVData.image_path(large_icon), 'minions/large')
      create_image(minion[:id], XIVData.image_path(minion.delete(:icon)), 'minions/small')
      create_image(minion[:id], XIVData.image_path(footprint_icon), 'minions/footprint', mask_from: '#151515ff')

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

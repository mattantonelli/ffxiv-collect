MINION_COLUMNS = %w(ID BehaviorTargetID Cost Attack Defense Description_* DescriptionEnhanced_*
GamePatch.Version HP HasAreaAttack Icon IconSmall IconID MinionRaceTargetID Name_* SkillAngle
SkillCost SpecialActionName_* SpecialActionDescription_* Speed StrengthArcana StrengthEye StrengthGate
StrengthShield Tooltip_* MinionSkillTypeTargetID Order).freeze

namespace :minions do
  desc 'Create the minions'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating minions'

    XIVAPI_CLIENT.content(name: 'CompanionMove', columns: %w(ID Name_*)).each do |type|
      if type[:name_en].present?
        data = type.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja)
        MinionBehavior.find_or_create_by!(data)
      end
    end

    XIVAPI_CLIENT.content(name: 'MinionRace', columns: %w(ID Name_*)).each do |race|
      if race[:name_en].present?
        data = race.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja)
        MinionRace.find_or_create_by!(data)
      end
    end

    XIVAPI_CLIENT.content(name: 'MinionSkillType', columns: %w(ID Name_*)).each do |type|
      if type[:name_en].present?
        data = type.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja)
        MinionSkillType.find_or_create_by!(data)
      end
    end

    count = Minion.count
    XIVAPI_CLIENT.content(name: 'Companion', columns: MINION_COLUMNS, limit: 1000).each do |minion|
      next unless minion.name_en.present?

      skill_type_id = minion.minion_skill_type_target_id.to_i
      skill_type_id = nil if skill_type_id == 0

      data = { id: minion.id, cost: minion.cost, attack: minion.attack, defense: minion.defense, hp: minion.hp,
               speed: minion.speed, skill_angle: minion.skill_angle, skill_cost: minion.skill_cost,
               area_attack: minion.has_area_attack == 1, patch: minion.game_patch.version,
               arcana: minion.strength_arcana == 1, eye: minion.strength_eye == 1,
               gate: minion.strength_gate == 1, shield: minion.strength_shield == 1,
               behavior_id: minion.behavior_target_id.to_i, race_id: minion.minion_race_target_id.to_i,
               skill_type_id: skill_type_id, order: minion.order }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(minion["name_#{locale}"])
        data["skill_#{locale}"] = sanitize_name(minion["special_action_name_#{locale}"])
        data["skill_description_#{locale}"] = sanitize_text(minion["special_action_description_#{locale}"])
        data["enhanced_description_#{locale}"] = sanitize_text(minion["description_enhanced_#{locale}"])

        %w(description tooltip).each do |field|
          data["#{field}_#{locale}"] = sanitize_text(minion["#{field}_#{locale}"])
        end
      end

      download_image(minion.id, minion.icon, 'minions/large')
      download_image(minion.id, minion.icon_small, 'minions/small')

      footprint_id = (69500 + minion.icon_id - 4500).to_s.rjust(6, '0')
      download_image(minion.id, "/i/069000/#{footprint_id}.png", 'minions/footprint', '#151515ff')

      if existing = Minion.find_by(id: minion.id)
        data = data.symbolize_keys.except(:patch)
        existing.update!(data) if updated?(existing, data)
      else
        Minion.create!(data)
      end
    end

    create_spritesheet('minions/small')

    puts "Created #{Minion.count - count} new minions"
  end
end

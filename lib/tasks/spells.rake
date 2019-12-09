SPELL_COLUMNS = %w(ID Description_* Stats_* Icon GamePatch.Version).freeze
SPELL_STATS_REGEX = /[^>]+?\n/

namespace :spells do
  desc 'Create the blue magic spells'
  task create: :environment do
    puts 'Creating blue magic spells'

    SpellType.find_or_create_by!(name_en: 'Magic', name_de: 'Magie', name_fr: 'Magique', name_ja: '魔法')
    SpellType.find_or_create_by!(name_en: 'Physical', name_de: 'Physisch', name_fr: 'Physique', name_ja: '物理')

    spells = XIVAPI_CLIENT.content(name: 'AozAction', columns: %w(ID Action.Name_* Action.ID), limit: 1000)
      .each_with_object({}) do |spell, h|
      if spell.action.name_en.present?
        h[spell.id] = %w(en de fr ja).each_with_object({}) do |locale, names|
          names["name_#{locale}"] = sanitize_name(spell.action["name_#{locale}"])
        end

        h[spell.id][:action_id] = spell.action.id
      end
    end

    action_ids = spells.values.pluck(:action_id)
    XIVAPI_CLIENT.content(name: 'Action', columns: %w(ID Description_*), ids: action_ids, limit: 1000).each do |action|
      spell = spells.values.find { |spell| spell[:action_id] == action.id }

      %w(en de fr ja).each do |locale|
        spell["tooltip_#{locale}"] = sanitize_tooltip(action["description_#{locale}"])
      end

      spell.delete(:action_id)
    end

    count = Spell.count
    XIVAPI_CLIENT.content(name: 'AozActionTransient', columns: SPELL_COLUMNS, limit: 1000).each do |spell|
      next unless spells.key?(spell.id)

      data = spells[spell.id].merge(id: spell.id, patch: spell.game_patch.version)

      %w(en de fr ja).each do |locale|
        data["description_#{locale}"] = sanitize_text(spell["description_#{locale}"])
      end

      type, aspect, rank = spell.to_h.slice(:stats_en, :stats_de, :stats_fr, :stats_ja)
        .map { |_, stats| stats.scan(SPELL_STATS_REGEX) }.transpose
        .map { |stat| stat.map(&:strip) }

      type = SpellType.find_by(name_en: type[0])
      aspect = SpellAspect.find_or_create_by!(name_en: aspect[0], name_de: aspect[1], name_fr: aspect[2], name_ja: aspect[3])

      data.merge!(type_id: type.id, aspect_id: aspect.id, rank: rank[0].count('★'))

      download_image(spell.id, spell.icon, 'spells', nil, nil, 42, 42)

      if existing = Spell.find_by(id: spell.id)
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Spell.create!(data)
      end
    end

    create_spritesheet('spells')

    puts "Created #{Spell.count - count} new blue magic spells"
  end
end

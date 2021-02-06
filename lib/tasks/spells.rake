SPELL_STATS_REGEX = /[^>]+?(?:\n|$)/.freeze

namespace :spells do
  desc 'Create the Blue Magic spells'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating Blue Magic spells'

    # Create spell types
    SpellType.find_or_create_by!(name_en: 'Magic', name_de: 'Magie', name_fr: 'Magique', name_ja: '魔法')
    SpellType.find_or_create_by!(name_en: 'Physical', name_de: 'Physisch', name_fr: 'Physique', name_ja: '物理')

    count = Spell.count
    spells = XIVData.sheet('AozAction', raw: true).each_with_object({}) do |spell, h|
      next if spell['Action'] == '0'
      h[spell['Action']] = { id: spell['#'], aspects: {} }
    end

    %w(en de fr ja).each do |locale|
      XIVData.sheet('Action', locale: locale).each do |action|
        next unless spells.has_key?(action['#'])
        spells[action['#']]["name_#{locale}"] = sanitize_name(action['Name'])
      end
    end

    %w(en de fr ja).each do |locale|
      XIVData.sheet('ActionTransient', locale: locale).each do |action|
        next unless spells.has_key?(action['#'])
        spells[action['#']]["description_#{locale}"] = sanitize_skill_description(action['Description'])
      end
    end

    %w(en de fr ja).each do |locale|
      XIVData.sheet('AozActionTransient', locale: locale).each do |spell|
        data = spells.values.find { |s| s[:id] == spell['#'] }
        next unless data.present?

        data[:order] ||= spell['Number']
        data[:icon] ||= spell['Icon']
        data[:location] ||= sanitize_name(spell['Location']) if spell['Location'].present?
        data["tooltip_#{locale}"] = sanitize_text(spell['Description'])

        type, aspect, rank = spell['Stats'].scan(SPELL_STATS_REGEX).map(&:strip)

        data[:type_id] ||= SpellType.find_by(name_en: type).id.to_s
        data[:aspects]["name_#{locale}"] = aspect
        data[:rank] ||= rank.count('★').to_s
      end
    end

    other_type = SourceType.find_by(name: 'Other').id

    spells.values.each do |spell|
      aspect = SpellAspect.find_or_create_by!(spell.delete(:aspects))
      spell[:aspect_id] = aspect.id.to_s
      location = spell.delete(:location)

      create_image(spell[:id], spell.delete(:icon), 'spells', nil, nil, 42, 42)

      if existing = Spell.find_by(id: spell[:id])
        existing.update!(spell) if updated?(existing, spell)
      else
        spell = Spell.create!(spell)

        # Create a stub source based on the location provided by the spellbook for new spells
        spell.sources.create!(type_id: other_type, text: "Unreported / #{location}") if location.present?
      end
    end

    create_spritesheet('spells')

    puts "Created #{Spell.count - count} new blue magic spells"
  end
end

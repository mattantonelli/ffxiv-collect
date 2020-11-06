EMOTE_COLUMNS = %w(ID Name_* GamePatch.Version EmoteCategoryTargetID TextCommand Icon).freeze

namespace :emotes do
  desc 'Create the emotes'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating emotes'

    XIVAPI_CLIENT.content(name: 'EmoteCategory', columns: %w(ID Name_*)).each do |category|
      if category[:name_en].present?
        data = category.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja)
        EmoteCategory.find_or_create_by!(data)
      end
    end

    count = Emote.count
    XIVAPI_CLIENT.search(indexes: 'Emote', columns: EMOTE_COLUMNS, limit: 1000,
                         filters: 'UnlockLink>0,TextCommandTargetID>0').each do |emote|
      data = { id: emote.id, patch: emote.game_patch.version, category_id: emote.emote_category_target_id }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(emote["name_#{locale}"])
        commands = emote['text_command'].to_h.stringify_keys
          .values_at("command_#{locale}", "alias_#{locale}", "short_command_#{locale}", "short_alias_#{locale}")
        data["command_#{locale}"] = commands.reject(&:empty?).uniq.join(', ')
      end

      download_image(emote.id, emote.icon, 'emotes')

      if existing = Emote.find_by(id: emote.id)
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Emote.create!(data)
      end
    end

    create_spritesheet('emotes')

    puts "Created #{Emote.count - count} new emotes"
  end
end

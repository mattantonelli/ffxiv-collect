EMOTE_COLUMNS = %w(ID Name_* GamePatch.Version EmoteCategoryTargetID Icon).freeze

namespace :emotes do
  desc 'Create the emotes'
  task create: :environment do
    puts 'Creating emotes'

    XIVAPI_CLIENT.content(name: 'EmoteCategory', columns: %w(ID Name_*)).each do |category|
      EmoteCategory.find_or_create_by!(category.to_h) if category[:name_en].present?
    end

    count = Emote.count
    XIVAPI_CLIENT.search(indexes: 'Emote', columns: EMOTE_COLUMNS, limit: 1000,
                         filters: 'UnlockLink>0,TextCommandTargetID>0').each do |emote|
      data = { id: emote.id, patch: emote.game_patch.version, category_id: emote.emote_category_target_id }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(emote["name_#{locale}"])
      end

      download_image(emote.id, emote.icon, 'emotes')

      if existing = Emote.find_by(id: emote.id)
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Emote.create!(data)
      end
    end

    create_spritesheet(Emote, 'emotes', 'emotes.png', 40, 40)

    puts "Created #{Emote.count - count} new emotes"
  end
end

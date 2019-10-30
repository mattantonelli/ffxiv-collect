ARMOIRE_COLUMNS = %w(ID Order CategoryTargetID Item.ID Item.Icon Item.Name_* Item.Description_en).freeze
ARMOIRE_ITEM_COLUMNS = %w(ID GameContentLinks.Achievement.Item GamePatch.Version).freeze

namespace :armoires do
  desc 'Create the armoire items'
  task create: :environment do
    puts 'Creating armoire items'

    XIVAPI_CLIENT.content(name: 'CabinetCategory', columns: %w(ID Category.Text_* MenuOrder)).each do |category|
      next unless category.menu_order > 0
      data = { id: category.id, order: category.menu_order }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = category.category["text_#{locale}"]
      end

      ArmoireCategory.find_or_create_by!(data)
    end

    count = Armoire.count
    armoires = XIVAPI_CLIENT.content(name: 'Cabinet', columns: ARMOIRE_COLUMNS, limit: 1000).map do |armoire|
      next if armoire.order == 0 || armoire.item.name_en.empty?
      data = { id: armoire.id + 1, category_id: armoire.category_target_id, order: armoire.order }

      data[:gender] = case armoire.item.description_en
                      when /♂/ then 'male'
                      when /♀/ then 'female'
                      end

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(armoire.item["name_#{locale}"])
      end

      download_image(data[:id], armoire.item.icon, 'armoires')

      if existing = Armoire.find_by(id: data[:id])
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
        nil
      else
        Armoire.create!(data)
      end

      data.merge(item_id: armoire.item.id)
    end

    # Add patch data and achievement sources
    item_ids = armoires.compact!.pluck(:item_id)
    achievement_type = SourceType.find_by(name: 'Achievement')

    item_ids.each_slice(1000) do |ids|
      [*XIVAPI_CLIENT.content(name: 'Item', ids: ids, columns: ARMOIRE_ITEM_COLUMNS, limit: 1000)].each do |item|
        id = armoires.find { |armoire| armoire[:item_id] == item.id }[:id]
        achievement_id = item.game_content_links.achievement.item&.first
        armoire = Armoire.find(id)

        armoire.update!(patch: item.game_patch.version)

        if achievement_id.present?
          achievement = Achievement.find(achievement_id)
          armoire.sources.find_or_create_by!(type: achievement_type, text: achievement.name_en,
                                             related_type: 'Achievement', related_id: achievement_id)
        end
      end
    end

    create_spritesheet('armoires')

    puts "Created #{Armoire.count - count} new armoire items"
  end
end

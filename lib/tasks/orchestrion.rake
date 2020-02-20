ORCHESTRION_COLUMNS = %w(ID Description_* GamePatch.Version Name_* OrchestrionUiparam.OrchestrionCategoryTargetID
OrchestrionUiparam.Order).freeze

namespace :orchestrions do
  desc 'Create the orchestrion rolls'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating orchestrion categories'
    XIVAPI_CLIENT.content(name: 'OrchestrionCategory', columns: %w(ID Name_*)).each do |category|
      next if category.id == 1
      if category[:name_en].present?
        data = category.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja)

        if existing = OrchestrionCategory.find_by(id: data[:id])
          existing.update!(data) if updated?(existing, data.symbolize_keys)
        else
          OrchestrionCategory.find_or_create_by!(data)
        end
      end
    end

    puts 'Creating orchestrion rolls'
    count = Orchestrion.count
    XIVAPI_CLIENT.content(name: 'Orchestrion', columns: ORCHESTRION_COLUMNS, limit: 1000).each do |orchestrion|
      next unless orchestrion.name_en.present?

      order = orchestrion.orchestrion_uiparam.order
      data = { id: orchestrion.id, patch: orchestrion.game_patch.version, order: order == 65535 ? nil : order,
               category_id: orchestrion.orchestrion_uiparam.orchestrion_category_target_id }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(orchestrion["name_#{locale}"])
        data["description_#{locale}"] = sanitize_text(orchestrion["description_#{locale}"])
      end

      if existing = Orchestrion.find_by(id: orchestrion.id)
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Orchestrion.create!(data)
      end
    end

    puts "Created #{Orchestrion.count - count} new orchestrion rolls"
  end
end

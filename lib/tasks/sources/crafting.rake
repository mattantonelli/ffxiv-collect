namespace 'sources:crafting' do
  desc 'Create sources from craftable items'
  task update: :environment do
    PaperTrail.enabled = false
    crafting_type = SourceType.find_by(name_en: 'Crafting')

    puts 'Creating Crafting sources'

    Item.where.not(unlock_type: nil).where.not(recipe_id: nil).each do |item|
      # Don't create a Crafting source for a collectable if one already exists.
      # This allows us to modify the text without worrying about this task making a duplicate source.
      unless Source.exists?(collectable_id: item.unlock_id, collectable_type: item.unlock_type, type: crafting_type)
        Source.find_or_create_by!(collectable_id: item.unlock_id, collectable_type: item.unlock_type,
                                  text: "Crafted by #{item.crafter}", type: crafting_type, related_id: item.recipe_id)
      end
    end
  end
end

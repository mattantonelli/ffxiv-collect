namespace 'sources:crafting' do
  desc 'Create sources from craftable items'
  task update: :environment do
    PaperTrail.enabled = false
    crafting_type = SourceType.find_by(name: 'Crafting')

    puts 'Creating Crafting sources'

    Item.where.not(unlock_type: nil).where.not(recipe_id: nil).each do |item|
      Source.find_or_create_by!(collectable_id: item.unlock_id, collectable_type: item.unlock_type,
                                text: "Crafted by #{item.crafter}", type: crafting_type, related_id: item.recipe_id)
    end
  end
end

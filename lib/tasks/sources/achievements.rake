namespace 'sources:achievements' do
  desc 'Create sources from Achievement rewards for non-time limited quests'
  task update: :environment do
    PaperTrail.enabled = false
    achievement_type = SourceType.find_by(name: 'Achievement')

    puts 'Creating Achievement sources'

    achievements = Achievement.exclude_time_limited.joins(:item)
      .where('items.unlock_type is not null')
      .where('items.unlock_type <> "Orchestrion"')

    achievements.each do |achievement|
      Source.find_or_create_by!(collectable_id: achievement.item.unlock_id, collectable_type: achievement.item.unlock_type,
                                text: achievement.name_en, type: achievement_type, related_id: achievement.id)
    end
  end
end

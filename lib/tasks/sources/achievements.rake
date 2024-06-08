namespace 'sources:achievements' do
  desc 'Create sources from Achievement rewards for non-time limited quests'
  task update: :environment do
    PaperTrail.enabled = false
    achievement_type = SourceType.find_by(name_en: 'Achievement')

    puts 'Creating Achievement sources'

    achievements = Achievement.exclude_time_limited.joins(:item)
      .where('items.unlock_type is not null')

    achievements.each do |achievement|
      collectable_id = achievement.item.unlock_id
      collectable_type = achievement.item.unlock_type

      next if Source.exists?(collectable_id: collectable_id, collectable_type: collectable_type,
                             type: achievement_type)

      Source.create!(collectable_id: collectable_id, collectable_type: collectable_type,
                     type: achievement_type, related_id: achievement.id,
                     text_en: achievement.name_en, text_de: achievement.name_de,
                     text_fr: achievement.name_fr, text_ja: achievement.name_ja)
    end
  end
end

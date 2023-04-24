namespace 'sources:quests' do
  desc 'Create sources from quest rewards'
  task update: :environment do
    PaperTrail.enabled = false

    puts 'Creating Quest sources'

    event_type = SourceType.find_by(name_en: 'Event')
    quest_type = SourceType.find_by(name_en: 'Quest')

    Item.includes(:quest).where.not(unlock_id: nil).where.not(quest_id: nil).each do |item|
      source_type = item.quest.event? ? event_type : quest_type

      if item.unlock.sources.none?
        item.unlock.sources.find_or_create_by!(text: item.quest.name_en, type: source_type,
                                               related_id: item.quest_id, limited: item.quest.event?)
      end
    end
  end
end

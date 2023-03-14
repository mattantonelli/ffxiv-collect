namespace 'sources:quests' do
  desc 'Create sources from quest rewards'
  task update: :environment do
    PaperTrail.enabled = false

    puts 'Creating Quest sources'

    event_type = SourceType.find_by(name: 'Event')
    quest_type = SourceType.find_by(name: 'Quest')

    Item.includes(:quest).where.not(unlock_id: nil).where.not(quest_id: nil).each do |item|
      if item.unlock_type == 'Orchestrion'
        item.unlock.update!(details: item.quest.name_en) unless item.unlock.details.present?
      else
        source_type = item.quest.event? ? event_type : quest_type

        if item.unlock.sources.none?
          item.unlock.sources.find_or_create_by!(text: item.quest.name_en, type: source_type,
                                                 related_id: item.quest_id, limited: item.quest.event?)
        end
      end
    end
  end
end

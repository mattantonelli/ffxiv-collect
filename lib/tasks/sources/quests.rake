namespace 'sources:quests' do
  desc 'Create sources from quest rewards'
  task update: :environment do
    PaperTrail.enabled = false

    puts 'Creating Quest sources'

    event_type = SourceType.find_by(name_en: 'Event')
    quest_type = SourceType.find_by(name_en: 'Quest')

    Item.includes(:quest).where.not(unlock_id: nil).where.not(quest_id: nil).each do |item|
      next if item.unlock.sources.any?

      source_type = item.quest.event? ? event_type : quest_type

      item.unlock.sources.find_or_create_by!(text_en: item.quest.name_en, text_de: item.quest.name_de,
                                             text_fr: item.quest.name_fr, text_ja: item.quest.name_ja,
                                             type: source_type, limited: item.quest.event?,
                                             related_type: 'Quest', related_id: item.quest_id)
    end
  end
end

namespace :relics do
  namespace :tools do
    desc 'Create relic tools'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating relic tools'
      count = Relic.count

      ## Lucis
      type = RelicType.find_or_create_by!(name_en: "Lucis Tools", name_de: "Lucis Werkzeuge",
                                          name_fr: "Outils Lucis",
                                          category: 'tools', order: 1, jobs: 11, expansion: 2)

      ids = [2327, 2354, 2379, 2404, 2429, 2455, 2480, 2506, 2532, 2558, 2584] + # Base
        (8436..8446).to_a +  # Supra
        (10132..10142).to_a # Lucis

      create_relics(type, ids)

      ## Skysteel
      type = RelicType.find_or_create_by!(name_en: "Skysteel Tools", name_de: "Himmelsstahl-Werkzeuge",
                                          name_fr: "Outils de Cielacier",
                                          category: 'tools', order: 2, jobs: 11, expansion: 5)

      ids = (29612..29644).to_a + # Skysteel -> Dragonsung
        (30282..30292).to_a + # Augmented Dragonsung
        (30293..30303).to_a + # Skysung
        (31714..31724).to_a  # Skybuilders'

      # Fix axe/pickaxe being out of order
      7.times do |i|
        ids.insert(11 * i + 8, ids.delete_at(11 * i + 9))
      end

      achievement_ids = AchievementCategory.find_by(name_en: 'Skysteel Tools').achievements.pluck(:id).sort
      achievement_ids = achievement_ids[0..10] * 5 + achievement_ids[11..-1]

      create_relics(type, ids, achievement_ids)

      ## Resplendent
      type = RelicType.find_or_create_by!(name_en: "Resplendent Tools", name_de: "Prachtwerkzeuge",
                                          name_fr: "Outils resplendissants",
                                          category: 'tools', order: 3, jobs: 11, expansion: 5)

      ids = (33154..33161).to_a + # Resplendent DoH
        (33356..33358).to_a  # Resplendent DoL

      achievement_ids = [2821, 2822, 2823, 2824, 2826, 2825, 2827, 2828, 2830, 2831, 2832]

      create_relics(type, ids, achievement_ids)

      ## Splendorous
      type = RelicType.find_or_create_by!(name_en: "Splendorous Tools", name_de: "Mowen-Werkzeuge",
                                          name_fr: "Outils des merveilles", name_ja: "モーエンツール",
                                          category: 'tools', order: 4, jobs: 11, expansion: 6)

      ids = (38715..38747).to_a + # Splendorous -> Crystalline
        (39732..39753).to_a + # Chora-Zoi -> Brilliant
        (41180..41201).to_a # Vrandtic -> Lodestar

      achievement_ids = (3193..3203).to_a * 3 +
        (3305..3315).to_a * 2 +
        (3362..3372).to_a * 2

      create_relics(type, ids, achievement_ids)

      ## Cosmic
      type = RelicType.find_or_create_by!(name_en: "Cosmic Tools", name_de: "Kosmo-Werkzeuge",
                                          name_fr: "Outils cosmiques", name_ja: "コスモツール",
                                          category: 'tools', order: 5, jobs: 11, expansion: 7)

      ids = (45679..45689).to_a # Cosmic

      achievement_ids = (3691..3701).to_a

      create_relics(type, ids, achievement_ids)

      puts "Created #{Relic.count - count} new relic tools"
    end
  end
end

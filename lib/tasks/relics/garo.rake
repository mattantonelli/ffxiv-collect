namespace :relics do
  namespace :garo do
    desc 'Create GARO equipment'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating GARO equipment'
      count = Relic.count

      ## Weapons
      type = RelicType.find_or_create_by!(name_en: "GARO Weapons", name_de: "GARO Waffen", name_fr: "Armes GARO",
                                          category: 'garo', order: 1, jobs: 13, expansion: 3)

      ids = 16067..16079
      achievement_ids = [1758, 1762, 1759, 1761, 1764, 1763, 1760, 1765, 1768, 1766, 1767, 1769, 1770]

      create_relics(type, ids, achievement_ids)

      ## Armor
      type = RelicType.find_or_create_by!(name_en: "GARO Armor", name_de: "GARO Rüstung", name_fr: "Armure GARO",
                                          category: 'garo', order: 2, jobs: 17, expansion: 3)

      ids = (16081..16145).to_a + # Original
        (37442..37461).to_a # 6.1
      achievement_ids = [1758] * 5 + [1759] * 5 + [1760] * 5 + [1761] * 5 + [1763] * 5

      create_relics(type, ids, achievement_ids)

      puts "Created #{Relic.count - count} new GARO equipment"
    end
  end
end

namespace :relics do
  desc 'Create relics'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating relics'
    count = Relic.count

    ## A Relic Reborn
    type = RelicType.find_or_create_by!(name_en: "A Relic Reborn", name_de: "Restaurierung der Reliktwaffen",
                                        name_fr: "Armes antiques", category: 'weapons', order: 1, jobs: 10, expansion: 2)

    ids = [1675, 1746, 1816, 1885, 1955, 2052, 2140, 2213, 2214, 7888] + # Base
      (6257..6265).to_a + [9250] + # Zenith
      (7824..7832).to_a + [9251] + # Atma
      (7834..7842).to_a + [9252] + # Animus
      (7863..7871).to_a + [9253] + # Novus
      (8649..8657).to_a + [9254] + # Nexus
      (9491..9499).to_a + [9501] + # Legendary
      (10054..10062).to_a + [10064] # Zeta

    achievement_ids = [129, 130, 131, 132, 133, 134, 135, 597, 598, 1053]

    create_relics(type, ids, achievement_ids)

    ## Anima
    type = RelicType.find_or_create_by!(name_en: "Anima Weapons", name_de: "Anima Waffen", name_fr: "Armes anima",
                                        category: 'weapons', order: 3, jobs: 13, expansion: 3)
    ids = (13611..13623).to_a + # Base
      (13597..13609).to_a + # Awoken
      (13223..13235).to_a + # Anima
      (14870..14882).to_a + # Hyperconductive
      (15223..15235).to_a + # Alive
      (15237..15249).to_a + # Smart
      (15251..15263).to_a + # Done
      (16050..16062).to_a  # Really Done

    # Base (3) > ...
    achievement_ids = [1406, 1407, 1408, 1409, 1410, 1415, 1417, 1416, 1411, 1412, 1413, 1414, 1418] * 3 +
      [1499, 1500, 1501, 1502, 1503, 1508, 1510, 1509, 1504, 1505, 1506, 1507, 1511] +
      [1605, 1606, 1607, 1608, 1609, 1614, 1616, 1615, 1610, 1611, 1612, 1613, 1617] +
      [1667, 1668, 1669, 1670, 1671, 1676, 1678, 1677, 1672, 1673, 1674, 1675, 1679] +
      [1695, 1696, 1697, 1698, 1699, 1704, 1706, 1705, 1700, 1701, 1702, 1703, 1707] +
      [1708, 1709, 1710, 1711, 1712, 1717, 1719, 1718, 1713, 1714, 1715, 1716, 1720]

    create_relics(type, ids, achievement_ids)

    ## Eureka
    type = RelicType.find_or_create_by!(name_en: "Eureka Weapons", name_de: "Eureka Waffen", name_fr: "Armes Eurêka",
                                        category: 'weapons', order: 4, jobs: 15, expansion: 4)

    ids = (21942..21956).to_a + # Base
      (21958..21972).to_a + # Base +1
      (21974..21988).to_a + # Base +2
      (21990..22004).to_a + # Anemos
      (22925..22939).to_a + # Pagos
      (22941..22955).to_a + # Pagos +1
      (22957..22971).to_a + # Elemental
      (24039..24053).to_a + # Elemental +1
      (24055..24069).to_a + # Elemental +2
      (24071..24085).to_a + # Pyros
      (24643..24657).to_a + # Hydatos
      (24659..24673).to_a + # Hydatos +1
      (24675..24689).to_a + # Base Eureka
      (24691..24705).to_a + # Eureka
      (24707..24721).to_a   # Physeos

    # Anemos (4) > Elemental (3) > Pyros (3) > Eureka (4)
    achievement_ids = [2030, 2034, 2031, 2033, 2037, 2035, 2032, 2038, 2042, 2039, 2040, 2043, 2044, 2036, 2041] * 4 +
      [2082, 2086, 2083, 2085, 2089, 2087, 2084, 2090, 2094, 2091, 2092, 2095, 2096, 2088, 2093] * 3 +
      [2143, 2147, 2144, 2146, 2150, 2148, 2145, 2151, 2155, 2152, 2153, 2156, 2157, 2149, 2154] * 3 +
      [2212, 2216, 2213, 2215, 2219, 2217, 2214, 2220, 2224, 2221, 2222, 2225, 2226, 2218, 2223] * 4

    create_relics(type, ids, achievement_ids)

    ## Resistance
    type = RelicType.find_or_create_by!(name_en: "Resistance Weapons", name_de: "Wiederstands-Waffen",
                                        name_fr: "Armes de la résistance", category: 'weapons',
                                        order: 6, jobs: 17, expansion: 5)

    ids = (30228..30244).to_a + # Base
      (30767..30783).to_a + # Augmented
      (30785..30801).to_a + # Recollection
      (32651..32667).to_a + # Law's Order
      (32669..32685).to_a + # Augmented Law's Order
      (33462..33478).to_a   # Blade's

    # Base  > Recollection (2) > Augmented Law's Order (2) > Blade's (2)
    achievement_ids = [2569, 2574, 2570, 2573, 2577, 2575, 2571, 2578, 2583, 2580, 2581, 2584, 2585, 2576, 2582, 2572, 2579] +
      [2694, 2699, 2695, 2698, 2702, 2700, 2696, 2703, 2708, 2705, 2706, 2709, 2710, 2701, 2707, 2697, 2704] * 2 +
      [2768, 2773, 2769, 2772, 2776, 2774, 2770, 2777, 2782, 2779, 2780, 2783, 2784, 2775, 2781, 2771, 2778] * 2 +
      [2857, 2862, 2858, 2861, 2865, 2863, 2859, 2866, 2871, 2868, 2869, 2872, 2873, 2864, 2870, 2860, 2867] * 2

    create_relics(type, ids, achievement_ids)

    ## Deep Dungeon
    type = RelicType.find_or_create_by!(name_en: "Deep Dungeon Weapons", name_de: "Tiefes Gewölbe - Waffen",
                                        name_fr: "Armes Donjons sans fond", category: 'weapons', order: 2, jobs: 19)

    ids = (15181..15193).to_a + [20456, 20457, 27347, 27348, 35756, 35774] + # Padjali
      (16152..16164).to_a + [20458, 20459, 27349, 27350, 35757, 35775] + # Kinna
      (22977..22991).to_a + [27379, 27380, 35759, 35777] # Empyrean

    achievement_ids = [1581, 1582, 1583, 1584, 1585, 1588, 1591, 1592, 1587, 1586, 1589, 1590, 1593, 1962, 1963,
                       2394, 2395, 3001, 3002]

    create_relics(type, ids, achievement_ids)

    # Eureka armor
    ## Eureka
    type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor", name_de: "Eureka Job Rüstung",
                                        name_fr: "Amure de classe d'Eurêka", category: 'armor',
                                        order: 1, jobs: 15, expansion: 4)
    ids = 22006..22080
    create_relics(type, ids)

    ## Eureka +1
    type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor +1", name_de: "Eureka Job Rüstung +1",
                                        name_fr: "Amure de classe d'Eurêka +1", category: 'armor',
                                        order: 2, jobs: 15, expansion: 4)
    ids = 22081..22155
    create_relics(type, ids)

    ## Eureka +2
    type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor +2", name_de: "Eureka Job Rüstung +2",
                                        name_fr: "Amure de classe d'Eurêka +2", category: 'armor',
                                        order: 3, jobs: 15, expansion: 4)
    ids = 22156..22230
    create_relics(type, ids)

    ## Anemos
    type = RelicType.find_or_create_by!(name_en: "Eureka Anemos Armor", name_de: "Eureka (Anemos) Rüstung",
                                        name_fr: "Armure Eurêka Anemos", category: 'armor',
                                        order: 4, jobs: 15, expansion: 4)
    ids = 22231..22305
    create_relics(type, ids)

    ## Elemental
    type = RelicType.find_or_create_by!(name_en: "Elemental Armor", name_de: "Elementar Rüstun",
                                        name_fr: "Armure élémentaire", category: 'armor', order: 5, jobs: 7, expansion: 4)
    ids = 24087..24121
    create_relics(type, ids)

    ## Elemental +1
    type = RelicType.find_or_create_by!(name_en: "Elemental Armor +1", name_de: "Elementar Rüstun +1",
                                        name_fr: "Armure élémentaire +1", category: 'armor', order: 6, jobs: 7, expansion: 4)
    ids = 24723..24757
    create_relics(type, ids)

    ## Elemental +2
    type = RelicType.find_or_create_by!(name_en: "Elemental Armor +2", name_de: "Elementar Rüstun +2",
                                        name_fr: "Armure élémentaire +2", category: 'armor', order: 7, jobs: 7, expansion: 4)
    ids = 24758..24792
    create_relics(type, ids)

    # Bozjan armor
    ## Idealized
    type = RelicType.find_or_create_by!(name_en: "Idealized Armor", name_de: "Idealisierte Rüstung",
                                        name_fr: "Armures des idéalistes", category: 'armor', order: 8, jobs: 17, expansion: 5)
    ids = 30142..30226
    create_relics(type, ids)

    ## Bozjan
    type = RelicType.find_or_create_by!(name_en: "Bozjan Armor", name_de: "Bozja Rüstung",
                                        name_fr: "Armure de Bozjan", category: 'armor', order: 9, jobs: 7, expansion: 5)
    ids = 30715..30749
    create_relics(type, ids)

    ## Augmented Bozjan
    type = RelicType.find_or_create_by!(name_en: "Augmented Bozjan Armor", name_de: "Modifizierte Bozja Rüstung",
                                        name_fr: "Armure améliorée de Bozjan", category: 'armor',
                                        order: 10, jobs: 7, expansion: 5)
    ids = 31358..31392
    create_relics(type, ids)

    ## Law's Order
    type = RelicType.find_or_create_by!(name_en: "Law's Order", name_de: "Richterspruch-Ausrüstung",
                                        name_fr: "Armure du verdict des Juge", category: 'armor',
                                        order: 11, jobs: 7, expansion: 5)
    ids = 32723..32757
    create_relics(type, ids)

    ## Augmented Law's Order
    type = RelicType.find_or_create_by!(name_en: "Augmented Law's Order", name_de: "Modifizierte Richterspruch-Ausrüstung",
                                        name_fr: "Armure du verdict des Juges améliorée", category: 'armor',
                                        order: 12, jobs: 7, expansion: 5)
    ids = 32758..32792
    create_relics(type, ids)

    ## Blade's
    type = RelicType.find_or_create_by!(name_en: "Blade's Armor", name_de: "Gunnhildrs Rüstung",
                                        name_fr: "Armure de Gunnhildr", category: 'armor', order: 13, jobs: 7, expansion: 5)
    ids = 33613..33647
    create_relics(type, ids)

    # Tools
    ## Lucis
    type = RelicType.find_or_create_by!(name_en: "Lucis Tools", name_de: "Lucis Werkzeuge",
                                        name_fr: "Outils Lucis", category: 'tools', order: 1, jobs: 11, expansion: 2)

    ids = [2327, 2354, 2379, 2404, 2429, 2455, 2480, 2506, 2532, 2558, 2584] + # Base
      (8436..8446).to_a +  # Supra
      (10132..10142).to_a # Lucis

    create_relics(type, ids)

    ## Skysteel
    type = RelicType.find_or_create_by!(name_en: "Skysteel Tools", name_de: "Himmelsstahl-Werkzeuge",
                                        name_fr: "Outils de Cielacier", category: 'tools', order: 2, jobs: 11, expansion: 5)

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
                                        name_fr: "Outils resplendissants", category: 'tools', order: 3, jobs: 11, expansion: 5)

    ids = (33154..33161).to_a + # Resplendent DoH
      (33356..33358).to_a  # Respldent DoL

    achievement_ids = [2821, 2822, 2823, 2824, 2826, 2825, 2827, 2828, 2830, 2831, 2832]

    create_relics(type, ids, achievement_ids)

    puts "Created #{Relic.count - count} new relics"
  end

  def create_relics(type, ids, achievement_ids = [])
    ids = ids.to_a

    Item.where(id: ids).sort_by { |item| ids.index(item.id) }.each_with_index do |item, i|
      data = { id: item.id.to_s, order: (i + 1).to_s, type_id: type.id.to_s, achievement_id: achievement_ids[i]&.to_s }
        .merge(item.slice(:name_en, :name_de, :name_fr, :name_ja))

      create_image(data[:id], XIVData.icon_path(item.icon_id), "relics/#{type.category}")

      if existing = Relic.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data)
      else
        Relic.create!(data)
      end
    end

    create_spritesheet("relics/#{type.category}")
  end
end

namespace :relics do
  namespace :weapons do
    desc 'Create relic weapons'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating relic weapons'
      count = Relic.count

      ## A Relic Reborn
      type = RelicType.find_or_create_by!(name_en: "A Relic Reborn", name_de: "Restaurierung der Reliktwaffen",
                                          name_fr: "Armes antiques", category: 'weapons',
                                          order: 1, jobs: 10, expansion: 2)

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
      type = RelicType.find_or_create_by!(name_en: "Anima Weapons", name_de: "Anima Waffen",
                                          name_fr: "Armes anima", category: 'weapons',
                                          order: 3, jobs: 13, expansion: 3)
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
      type = RelicType.find_or_create_by!(name_en: "Eureka Weapons", name_de: "Eureka Waffen",
                                          name_fr: "Armes Eurêka", category: 'weapons',
                                          order: 4, jobs: 15, expansion: 4)

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
      type = RelicType.find_or_create_by!(name_en: "Resistance Weapons", name_de: "Widerstands-Waffen",
                                          name_fr: "Armes de la résistance", category: 'weapons',
                                          order: 6, jobs: 17, expansion: 5)

      ids = (30228..30244).to_a + # Base
        (30767..30783).to_a + # Augmented
        (30785..30801).to_a + # Recollection
        (32651..32667).to_a + # Law's Order
        (32669..32685).to_a + # Augmented Law's Order
        (33462..33478).to_a   # Blade's

      # Base > Recollection (2) > Augmented Law's Order (2) > Blade's (2)
      achievement_ids = [2569, 2574, 2570, 2573, 2577, 2575, 2571, 2578, 2583, 2580, 2581, 2584, 2585, 2576, 2582, 2572, 2579] +
        [2694, 2699, 2695, 2698, 2702, 2700, 2696, 2703, 2708, 2705, 2706, 2709, 2710, 2701, 2707, 2697, 2704] * 2 +
        [2768, 2773, 2769, 2772, 2776, 2774, 2770, 2777, 2782, 2779, 2780, 2783, 2784, 2775, 2781, 2771, 2778] * 2 +
        [2857, 2862, 2858, 2861, 2865, 2863, 2859, 2866, 2871, 2868, 2869, 2872, 2873, 2864, 2870, 2860, 2867] * 2

      create_relics(type, ids, achievement_ids)

      ## Manderville
      type = RelicType.find_or_create_by!(name_en: "Manderville Weapons", name_de: "Manderville-Waffen",
                                          name_fr: "Armes des Manderville", category: 'weapons',
                                          order: 7, jobs: 19, expansion: 6)

      ids = (38400..38418).to_a + # Base
        (39144..39162).to_a + # Amazing
        (39920..39938).to_a + # Majestic
        (40932..40950).to_a # Mandervillous

      # Base > Amazing > Majestic
      achievement_ids = [3128, 3133, 3129, 3132, 3137, 3134, 3130, 3138, 3143, 3140, 3141, 3144, 3145, 3135, 3142, 3131, 3139, 3146, 3136] +
        [3224, 3229, 3225, 3228, 3233, 3230, 3226, 3234, 3239, 3236, 3237, 3240, 3241, 3231, 3238, 3227, 3235, 3242, 3232] +
        [3285, 3290, 3286, 3289, 3294, 3291, 3287, 3295, 3300, 3297, 3298, 3301, 3302, 3292, 3299, 3288, 3296, 3303, 3293] +
        [3380, 3385, 3381, 3384, 3389, 3386, 3382, 3390, 3395, 3392, 3393, 3396, 3397, 3387, 3394, 3383, 3391, 3398, 3388]

      create_relics(type, ids, achievement_ids)

      ## Exquisite
      type = RelicType.find_or_create_by!(name_en: "Exquisite Weapons", name_de: "Exquisite Waffen",
                                        name_fr: "Armes magnifiées", category: 'weapons',
                                        order: 8, jobs: 21, expansion: 7)

      ids = (41679..41697).to_a + [44243, 44244]

      create_relics(type, ids)

      ## Phantom

      # Penumbrae > Umbrae
      ids = [47869, 47870, 47871, 47872, 47873, 47878, 47879, 47880, 47874, 47875, 47876, 47877, 47881, 47882, 47883, 47884, 47885, 47887, 47886, 47888, 47889] +
        [47006, 47007, 47008, 47009, 47010, 47015, 47016, 47017, 47011, 47012, 47013, 47014, 47018, 47019, 47020, 47021, 47022, 47024, 47023, 47025, 47026]

      achievement_ids = [3638, 3643, 3639, 3642, 3648, 3644, 3640, 3649, 3655, 3651, 3652, 3656, 3657, 3646, 3653, 3641, 3650, 3658, 3647, 3645, 3654] +
        [3752, 3757, 3753, 3756, 3762, 3758, 3754, 3763, 3769, 3765, 3766, 3770, 3771, 3760, 3767, 3755, 3764, 3772, 3761, 3759, 3768]

      type = RelicType.find_or_create_by!(name_en: "Phantom Weapons", name_de: "Phantomwaffen",
                                          name_fr: "Armes fantômes", category: 'weapons',
                                          order: 9, jobs: 21, expansion: 7)

      create_relics(type, ids, achievement_ids)

      ## Deep Dungeon
      type = RelicType.find_or_create_by!(name_en: "Deep Dungeon Weapons", name_de: "Tiefes Gewölbe - Waffen",
                                          name_fr: "Armes Donjons sans fond", category: 'weapons')
      type.update(order: 2, jobs: 21)

      ids = (15181..15193).to_a + [20456, 20457, 27347, 27348, 35756, 35774, 43633, 43654] + # Padjali
        (16152..16164).to_a + [20458, 20459, 27349, 27350, 35757, 35775, 43634, 43655] + # Kinna
        (22977..22991).to_a + [27379, 27380, 35759, 35777, 43635, 43656] + # Empyrean
        (39184..39200).to_a + [39202, 39201, 43636, 43657] + # Orthos
        (39204..39220).to_a + [39222, 39221, 43637, 43658] + # Enaretos
        [47028, 47029, 47030, 47031, 47032, 47037, 47038, 47039, 47033, 47034, 47035, 47036, 47040, 47041, 47042, 47043, 47044, 47045, 47046, 47047, 47048] + # First Light
        [47050, 47051, 47052, 47053, 47054, 47059, 47060, 47061, 47055, 47056, 47057, 47058, 47062, 47063, 47064, 47065, 47066, 47067, 47068, 47069, 47070] # Sacramental

      achievement_ids = [1581, 1582, 1583, 1584, 1585, 1588, 1591, 1592, 1587, 1586, 1589, 1590, 1593, 1962, 1963,
                         2394, 2395, 3001, 3002, 3538, 3539]

      create_relics(type, ids, achievement_ids)

      puts "Created #{Relic.count - count} new relic weapons"
    end
  end
end

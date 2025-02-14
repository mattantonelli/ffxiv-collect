namespace :relics do
  namespace :ultimate do
    desc 'Create ultimate weapons'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating ultimate weapons'
      count = Relic.count

      # UCoB
      type = RelicType.find_or_create_by!(name_en: "The Unending Coil of Bahamut",
                                          name_de: "Endlose Schatten von Bahamut",
                                          name_fr: "L'Abîme infini de Bahamut",
                                          name_ja: "絶バハムート討滅戦",
                                          category: 'ultimate', order: 1, jobs: 15)

      ids = (20959..20973).to_a
      create_relics(type, ids)

      # UwU
      type = RelicType.find_or_create_by!(name_en: "The Weapon's Refrain",
                                          name_de: "Heldenlied von Ultima",
                                          name_fr: "La Fantasmagorie d'Ultima",
                                          name_ja: "絶アルテマウェポン破壊作戦",
                                          category: 'ultimate', order: 2, jobs: 15)

      ids = (22868..22882).to_a
      create_relics(type, ids)

      # TEA
      type = RelicType.find_or_create_by!(name_en: "The Epic of Alexander",
                                          name_de: "Alexander",
                                          name_fr: "L'Odyssée d'Alexander",
                                          name_ja: "絶アレキサンダー討滅戦",
                                          category: 'ultimate', order: 3, jobs: 17)

      ids = (28289..28305).to_a
      create_relics(type, ids)

      # DSR
      type = RelicType.find_or_create_by!(name_en: "Dragonsong's Reprise",
                                          name_de: "Drachenkrieg",
                                          name_fr: "La Guerre du chant des dragons",
                                          name_ja: "絶竜詩戦争",
                                          category: 'ultimate', order: 4, jobs: 19)

      ids = (36943..36961).to_a
      create_relics(type, ids)

      # TOP
      type = RelicType.find_or_create_by!(name_en: "The Omega Protocol",
                                          name_de: "Omega",
                                          name_fr: "Le Protocole Oméga",
                                          name_ja: "絶オメガ検証戦",
                                          category: 'ultimate', order: 5, jobs: 21)

      ids = (39164..39182).to_a +
        [43642, 43663]
      create_relics(type, ids)

      # FRU
      type = RelicType.find_or_create_by!(name_en: "Futures Rewritten",
                                          name_de: "Eine zweite Zukunft",
                                          name_fr: "Avenirs réécrits",
                                          name_ja: "絶もうひとつの未来",
                                          category: 'ultimate', order: 6, jobs: 21)

      ids = [44721, 44722, 44723, 44724, 44725, 44730, 44731, 44732, 44726, 44727, 44728,
             44729, 44733, 44734, 44735, 44736, 44737, 44739, 44738, 44740, 44741]
      create_relics(type, ids)

      puts "Created #{Relic.count - count} new ultimate weapons"
    end
  end
end

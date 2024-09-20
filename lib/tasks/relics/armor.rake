namespace :relics do
  namespace :armor do
    desc 'Create relic armor'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating relic armor'
      count = Relic.count

      ## Eureka
      type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor", name_de: "Eureka Job Rüstung",
                                          name_fr: "Amure de classe d'Eurêka",
                                          category: 'armor', order: 1, jobs: 15, expansion: 4)
      ids = 22006..22080
      create_relics(type, ids)

      ## Eureka +1
      type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor +1", name_de: "Eureka Job Rüstung +1",
                                          name_fr: "Amure de classe d'Eurêka +1",
                                          category: 'armor', order: 2, jobs: 15, expansion: 4)
      ids = 22081..22155
      create_relics(type, ids)

      ## Eureka +2
      type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor +2", name_de: "Eureka Job Rüstung +2",
                                          name_fr: "Amure de classe d'Eurêka +2",
                                          category: 'armor', order: 3, jobs: 15, expansion: 4)
      ids = 22156..22230
      create_relics(type, ids)

      ## Anemos
      type = RelicType.find_or_create_by!(name_en: "Eureka Anemos Armor", name_de: "Eureka (Anemos) Rüstung",
                                          name_fr: "Armure Eurêka Anemos",
                                          category: 'armor', order: 4, jobs: 15, expansion: 4)
      ids = 22231..22305
      create_relics(type, ids)

      ## Elemental
      type = RelicType.find_or_create_by!(name_en: "Elemental Armor", name_de: "Elementar Rüstung",
                                          name_fr: "Armure élémentaire",
                                          category: 'armor', order: 5, jobs: 7, expansion: 4)
      ids = 24087..24121
      create_relics(type, ids)

      ## Elemental +1
      type = RelicType.find_or_create_by!(name_en: "Elemental Armor +1", name_de: "Elementar Rüstung +1",
                                          name_fr: "Armure élémentaire +1",
                                          category: 'armor', order: 6, jobs: 7, expansion: 4)
      ids = 24723..24757
      create_relics(type, ids)

      ## Elemental +2
      type = RelicType.find_or_create_by!(name_en: "Elemental Armor +2", name_de: "Elementar Rüstung +2",
                                          name_fr: "Armure élémentaire +2",
                                          category: 'armor', order: 7, jobs: 7, expansion: 4)
      ids = 24758..24792
      create_relics(type, ids)

      # Bozjan armor
      ## Idealized
      type = RelicType.find_or_create_by!(name_en: "Idealized Armor", name_de: "Idealisierte Rüstung",
                                          name_fr: "Armures des idéalistes",
                                          category: 'armor', order: 8, jobs: 17, expansion: 5)
      ids = 30142..30226
      create_relics(type, ids)

      ## Bozjan
      type = RelicType.find_or_create_by!(name_en: "Bozjan Armor", name_de: "Bozja Rüstung",
                                          name_fr: "Armure de Bozjan",
                                          category: 'armor', order: 9, jobs: 7, expansion: 5)
      ids = 30715..30749
      create_relics(type, ids)

      ## Augmented Bozjan
      type = RelicType.find_or_create_by!(name_en: "Augmented Bozjan Armor",
                                          name_de: "Modifizierte Bozja Rüstung",
                                          name_fr: "Armure améliorée de Bozjan",
                                          category: 'armor', order: 10, jobs: 7, expansion: 5)
      ids = 31358..31392
      create_relics(type, ids)

      ## Law's Order
      type = RelicType.find_or_create_by!(name_en: "Law's Order", name_de: "Richterspruch-Ausrüstung",
                                          name_fr: "Armure du verdict des Juge",
                                          category: 'armor', order: 11, jobs: 7, expansion: 5)
      ids = 32723..32757
      create_relics(type, ids)

      ## Augmented Law's Order
      type = RelicType.find_or_create_by!(name_en: "Augmented Law's Order",
                                          name_de: "Modifizierte Richterspruch-Ausrüstung",
                                          name_fr: "Armure du verdict des Juges améliorée",
                                          category: 'armor', order: 12, jobs: 7, expansion: 5)
      ids = 32758..32792
      create_relics(type, ids)

      ## Blade's
      type = RelicType.find_or_create_by!(name_en: "Blade's Armor", name_de: "Gunnhildrs Rüstung",
                                          name_fr: "Armure de Gunnhildr",
                                          category: 'armor', order: 13, jobs: 7, expansion: 5)
      ids = 33613..33647
      create_relics(type, ids)

      puts "Created #{Relic.count - count} new relic armor"
    end
  end
end

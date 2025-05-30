namespace :relics do
  namespace :armor do
    desc 'Create relic armor'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating relic armor'
      count = Relic.count

      # Stormblood - Eureka Armor
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


      # Shadowbringers - Bozja Armor
      ## Idealized
      type = RelicType.find_or_create_by!(name_en: "Idealized Armor", name_de: "Idealisierte Rüstung",
                                          name_fr: "Armures des idéalistes",
                                          category: 'armor', order: 1, jobs: 17, expansion: 5)
      ids = 30142..30226
      create_relics(type, ids)

      ## Bozjan
      type = RelicType.find_or_create_by!(name_en: "Bozjan Armor", name_de: "Bozja Rüstung",
                                          name_fr: "Armure de Bozjan",
                                          category: 'armor', order: 2, jobs: 7, expansion: 5)
      ids = 30715..30749
      create_relics(type, ids)

      ## Augmented Bozjan
      type = RelicType.find_or_create_by!(name_en: "Augmented Bozjan Armor",
                                          name_de: "Modifizierte Bozja Rüstung",
                                          name_fr: "Armure améliorée de Bozjan",
                                          category: 'armor', order: 3, jobs: 7, expansion: 5)
      ids = 31358..31392
      create_relics(type, ids)

      ## Law's Order
      type = RelicType.find_or_create_by!(name_en: "Law's Order", name_de: "Richterspruch-Ausrüstung",
                                          name_fr: "Armure du verdict des Juge",
                                          category: 'armor', order: 4, jobs: 7, expansion: 5)
      ids = 32723..32757
      create_relics(type, ids)

      ## Augmented Law's Order
      type = RelicType.find_or_create_by!(name_en: "Augmented Law's Order",
                                          name_de: "Modifizierte Richterspruch-Ausrüstung",
                                          name_fr: "Armure du verdict des Juges améliorée",
                                          category: 'armor', order: 5, jobs: 7, expansion: 5)
      ids = 32758..32792
      create_relics(type, ids)

      ## Blade's
      type = RelicType.find_or_create_by!(name_en: "Blade's Armor", name_de: "Gunnhildrs Rüstung",
                                          name_fr: "Armure de Gunnhildr",
                                          category: 'armor', order: 6, jobs: 7, expansion: 5)
      ids = 33613..33647
      create_relics(type, ids)


      # Dawntrail - Occult Crescent Armor
      ## Arcanaut's
      type = RelicType.find_or_create_by!(name_en: "Arcanaut's Armor", name_de: "Arkanaut-Rüstung",
                                          name_fr: "Armure de naufragé du croissant",
                                          category: 'armor', order: 1, jobs: 7, expansion: 7)

      ids = (47758..47762).to_a + (47773..47777).to_a + (47788..47792).to_a + (47803..47807).to_a +
        (47818..47822).to_a + (47833..47837).to_a + (47848..47852).to_a
      create_relics(type, ids)

      ## Arcanaut's +1
      type = RelicType.find_or_create_by!(name_en: "Arcanaut's Armor +1", name_de: "Arkanaut-Rüstung +1",
                                          name_fr: "Armure de naufragé du croissant +1",
                                          category: 'armor', order: 2, jobs: 7, expansion: 7)

      ids = (47763..47767).to_a + (47778..47782).to_a + (47793..47797).to_a + (47808..47812).to_a +
        (47823..47827).to_a + (47838..47842).to_a + (47853..47857).to_a
      create_relics(type, ids)

      ## Arcanaut's +2
      type = RelicType.find_or_create_by!(name_en: "Arcanaut's Armor +2", name_de: "Arkanaut-Rüstung +2",
                                          name_fr: "Armure de naufragé du croissant +2",
                                          category: 'armor', order: 3, jobs: 7, expansion: 7)

      ids = (47768..47772).to_a + (47783..47787).to_a + (47798..47802).to_a + (47813..47817).to_a +
        (47828..47832).to_a + (47843..47847).to_a + (47858..47862).to_a
      create_relics(type, ids)

      puts "Created #{Relic.count - count} new relic armor"
    end
  end
end

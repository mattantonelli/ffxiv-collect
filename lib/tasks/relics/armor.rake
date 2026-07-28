namespace :relics do
  namespace :armor do
    desc 'Create relic armor'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating relic armor'
      count = Relic.count

      # Display order: Fending, Maiming, Striking, Aiming, Scouting, Healing, Casting

      # Stormblood - Eureka Armor
      ## Eureka
      type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor", name_de: "Eureka Job Rüstung",
                                          name_fr: "Armure de classe d'Eurêka",
                                          category: 'armor', order: 1, jobs: 15, expansion: 4)
      ids = 22006..22080
      create_relics(type, ids)

      ## Eureka +1
      type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor +1", name_de: "Eureka Job Rüstung +1",
                                          name_fr: "Armure de classe d'Eurêka +1",
                                          category: 'armor', order: 2, jobs: 15, expansion: 4)
      ids = 22081..22155
      create_relics(type, ids)

      ## Eureka +2
      type = RelicType.find_or_create_by!(name_en: "Eureka Job Armor +2", name_de: "Eureka Job Rüstung +2",
                                          name_fr: "Armure de classe d'Eurêka +2",
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
                                          name_fr: "Armure du verdict des Juges",
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

      ## Phantom Vision
      type = RelicType.find_or_create_by!(name_en: "Phantom Vision", name_de: "Phantomtraum",
                                          name_fr: "Armure de vision fantomatique",
                                          category: 'armor', order: 4, jobs: 7, expansion: 7)

      ids = (51811..51815).to_a + (51831..51835).to_a + (51851..51855).to_a + (51871..51875).to_a +
        (51891..51895).to_a + (51911..51915).to_a + (51931..51935).to_a

      create_relics(type, ids)

      ## Phantom Vision +1
      type = RelicType.find_or_create_by!(name_en: "Phantom Vision +1", name_de: "Phantomtraum +1",
                                          name_fr: "Armure de vision fantomatique +1",
                                          category: 'armor', order: 5, jobs: 7, expansion: 7)

      ids = (51816..51820).to_a + (51836..51840).to_a + (51856..51860).to_a + (51876..51880).to_a +
        (51896..51900).to_a + (51916..51920).to_a + (51936..51940).to_a
      create_relics(type, ids)

      ## Phantom Vision +2
      type = RelicType.find_or_create_by!(name_en: "Phantom Vision +2", name_de: "Phantomtraum +2",
                                          name_fr: "Armure de vision fantomatique +2",
                                          category: 'armor', order: 6, jobs: 7, expansion: 7)

      ids = (51821..51825).to_a + (51841..51845).to_a + (51861..51865).to_a + (51881..51885).to_a +
        (51901..51905).to_a + (51921..51925).to_a + (51941..51945).to_a
      create_relics(type, ids)

      ## Phantom Vision +3
      type = RelicType.find_or_create_by!(name_en: "Phantom Vision +3", name_de: "Phantomtraum +3",
                                          name_fr: "Armure de vision fantomatique +3",
                                          category: 'armor', order: 7, jobs: 7, expansion: 7)

      ids = (51826..51830).to_a + (51846..51850).to_a + (51866..51870).to_a + (51886..51890).to_a +
        (51906..51910).to_a + (51926..51930).to_a + (51946..51950).to_a
      create_relics(type, ids)

      puts "Created #{Relic.count - count} new relic armor"
    end
  end
end

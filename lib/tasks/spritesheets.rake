namespace :spritesheets do
  desc 'Creates all spritesheets, used for generating production assets'
  task create: :environment do
    puts 'Creating mount spritesheets'
    create_spritesheet('mounts/small')

    puts 'Creating minion spritesheets'
    create_spritesheet('minions/small')

    puts 'Creating achievement spritesheet'
    create_spritesheet('achievements')
    create_spritesheet('items')

    puts 'Creating emote spritesheet'
    create_spritesheet('emotes')

    puts 'Creating barding spritesheet'
    create_spritesheet('bardings')

    puts 'Creating armoire spritesheet'
    create_spritesheet('armoires')

    puts 'Creating hairstyle spritesheets'
    create_hair_spritesheets

    puts 'Creating Blue Magic spell spritesheets'
    create_spritesheet('spells')

    puts 'Creating item spritesheets'
    create_spritesheet('relics/weapons')
    create_spritesheet('relics/armor')
    create_spritesheet('relics/tools')

    puts 'Creating fashion spritesheet'
    create_spritesheet('fashions/small')

    puts 'Creating record spritesheet'
    create_spritesheet('records/small')

    puts 'Creating survey record spritesheet'
    create_spritesheet('survey_records/small')

    puts 'Creating triple triad spritesheets'
    create_spritesheet('cards/small')
    create_spritesheet('cards/large')
    create_spritesheet('cards/large/red')
    create_spritesheet('cards/large/blue')
  end
end

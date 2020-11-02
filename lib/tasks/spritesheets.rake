namespace :spritesheets do
	desc 'Creates all spritesheets, used for generating production assets'
	task create: :environment do
    puts 'Creating mount spritesheets'
    create_spritesheet('mounts/small')

    puts 'Creating minion spritesheets'
    create_spritesheet('minions/small')

    puts 'Creating achievement spritesheet'
    create_spritesheet('achievements')

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
    create_spritesheet('items/weapons')
    create_spritesheet('items/armor')
    create_spritesheet('items/tools')

    puts 'Creating fashion spritesheets'
    create_spritesheet('fashions/small')
  end
end

namespace :spritesheets do
	desc 'Creates all spritesheets, used for generating production assets'
	task create: :environment do
    puts 'Creating mount spritesheets'
    create_spritesheet('mounts/large')
    create_spritesheet('mounts/small')
    create_spritesheet('mounts/footprint')

    puts 'Creating minion spritesheets'
    create_spritesheet('minions/large')
    create_spritesheet('minions/small')
    create_spritesheet('minions/footprint')

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
  end
end

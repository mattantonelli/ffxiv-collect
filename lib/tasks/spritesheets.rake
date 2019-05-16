namespace :spritesheets do
	desc 'Creates all spritesheets, used for generating production assets'
	task create: :environment do
    puts 'Creating mount spritesheets'
    create_spritesheet(Mount, 'mounts/large', 'mounts/large.png', 192, 192)
    create_spritesheet(Mount, 'mounts/small', 'mounts/small.png', 40, 40)
    create_spritesheet(Mount, 'mounts/footprint', 'mounts/footprint.png', 128, 128)

    puts 'Creating minion spritesheets'
    create_spritesheet(Minion, 'minions/large', 'minions/large.png', 192, 192)
    create_spritesheet(Minion, 'minions/small', 'minions/small.png', 40, 40)
    create_spritesheet(Minion, 'minions/footprint', 'minions/footprint.png', 128, 128)

    puts 'Creating emote spritesheet'
    create_spritesheet(Emote, 'emotes', 'emotes.png', 40, 40)

    puts 'Creating barding spritesheet'
    create_spritesheet(Barding, 'bardings', 'bardings.png', 40, 40)

    puts 'Creating armoire spritesheet'
    create_spritesheet(Armoire, 'armoires', 'armoires.png', 40, 40)

    puts 'Creating hair spritesheets'
    create_hair_spritesheets
  end
end

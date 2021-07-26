class YokaiController < ApplicationController
  include Collection
  before_action :check_achievements!
  skip_before_action :set_owned!, :set_ids!, :set_dates!, :set_prices!

  def index
    @minions = Achievement.where('name_en like ?', 'Watch Me If You Can%').order(:order)
    @weapons = Achievement.where('name_en like ?', 'Otherworldly%').order(:order)
    @mounts = Mount.where(id: [87, 94, 228]).order(:order)

    @achievement_ids = @character&.achievement_ids || []
    @mount_ids = @character&.mount_ids || []

    @details = @weapons.each_with_index.map do |weapon, i|
      name = @minions[i].name_en.gsub(/Watch Me If You Can: /, '')
      { minion: @minions[i], weapon: weapon, zones: yokai_zones[name] }
    end
  end

  private
  def yokai_zones
    {
      'Jibanyan' => ['Central Shroud', 'Lower La Noscea', 'Central Thanalan'],
      'Komasan' => ['East Shroud', 'Western La Noscea', 'Eastern Thanalan'],
      'Whisper' => ['South Shroud', 'Upper La Noscea', 'Southern Thanalan'],
      'Blizzaria' => ['North Shroud', 'Outer La Noscea', 'Middle La Noscea'],
      'Kyubi' => ['Western Thanalan', 'Central Shroud', 'Lower La Noscea'],
      'Komajiro' => ['Central Thanalan', 'East Shroud', 'Western La Noscea'],
      'Manjimutt' => ['Eastern Thanalan', 'South Shroud', 'Upper La Noscea'],
      'Noko' => ['Southern Thanalan', 'North Shroud', 'Outer La Noscea'],
      'Venoct' => ['Middle La Noscea', 'Western Thanalan', 'Central Shroud'],
      'Shogunyan' => ['Lower La Noscea', 'Central Thanalan', 'East Shroud'],
      'Hovernyan' => ['Western La Noscea', 'Eastern Thanalan', 'South Shroud'],
      'Robonyan F-type' => ['Upper La Noscea', 'Southern Thanalan', 'North Shroud'],
      'USApyon' => ['Outer La Noscea', 'Middle La Noscea', 'Western Thanalan'],
      'Lord Enma' => ['Stormblood Zones', '', ''],
      'Lord Ananta' => ['Heavensward Zones', '', ''],
      'Zazel' => ['Heavensward Zones', '', ''],
      'Damona' => ['Stormblood Zones', '', '']
    }.freeze
  end
end

class RelicsController < ApplicationController
  include ManualCollection
  before_action :check_achievements!, only: :weapons
  before_action :display_verify_alert!, only: [:tools, :gear]
  before_action :set_item_collection!, only: [:tools, :gear]
  skip_before_action :display_verify_alert!, only: :weapons
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def weapons
    flash.now[:alert_fixed] = 'Resistance Weapons achievements are currently missing from the Lodestone. As a result, your collection may not be up to date.'

    @anima_weapons = AchievementCategory.find_by(name_en: 'Anima Weapons').achievements.order(:order)
    @eureka_weapons = AchievementCategory.find_by(name_en: 'Eureka Weapons').achievements.order(:order)
    @resistance_weapons = AchievementCategory.find_by(name_en: 'Resistance Weapons').achievements.order(:order)
    @collection_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall('achievements')
    @dates = @character&.character_achievements&.pluck('achievement_id', :created_at).to_h || {}
  end

  def tools
    @lucis_tools = Item.where(id: Item.lucis_tool_ids)
    @skysteel_tools = Item.where(id: Item.skysteel_tool_ids)
  end

  def gear
    @arr_relic_weapons = Item.where(id: Item.arr_relic_ids).sort_by { |item| Item.arr_relic_ids.index(item.id) }

    @deep_dungeon_weapons = Item.where(id: Item.deep_dungeon_weapon_ids)
      .sort_by { |item| Item.deep_dungeon_weapon_ids.index(item.id) }

    @eureka_job_gear = ["Eureka Anemos Job Gear", "Eureka Job Gear +2", "Eureka Job Gear +1", "Eureka Job Gear"]
      .zip(Item.where(id: Item.eureka_job_gear_ids).each_slice(75).to_a.reverse).to_h

    @eureka_elemental_gear = ['Elemental Gear +2', 'Elemental Gear +1', 'Elemental Gear']
      .zip(Item.where(id: Item.eureka_elemental_gear_ids).each_slice(35).to_a.reverse).to_h
  end

  private
  def set_item_collection!
    @collection_ids = @character&.item_ids || []
    @owned = Redis.current.hgetall('items')
    @dates = @character&.character_items&.pluck('item_id', :created_at).to_h || {}
  end
end

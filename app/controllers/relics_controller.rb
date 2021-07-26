class RelicsController < ApplicationController
  include ManualCollection
  before_action :check_achievements!, only: :weapons
  before_action :display_verify_alert!, only: [:manual_weapons, :tools, :armor]
  before_action :set_relic_collection!, only: [:manual_weapons, :tools, :armor]
  skip_before_action :display_verify_alert!, only: :weapons
  skip_before_action :set_owned!, :set_ids!, :set_dates!, :set_prices!

  def weapons
    @anima_weapons = AchievementCategory.find_by(name_en: 'Anima Weapons').achievements.order(:order)
    @eureka_weapons = AchievementCategory.find_by(name_en: 'Eureka Weapons').achievements.order(:order)
    @resistance_weapons = AchievementCategory.find_by(name_en: 'Resistance Weapons').achievements.order(:order)
    @collection_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall('achievements')
    @dates = @character&.character_achievements&.pluck('achievement_id', :created_at).to_h || {}
  end

  def manual_weapons
    @arr_relic_weapons = Relic.where(id: Relic.arr_relic_weapon_ids)
      .sort_by { |relic| Relic.arr_relic_weapon_ids.index(relic.id) }
    @deep_dungeon_weapons = Relic.where(id: Relic.deep_dungeon_weapon_ids)
      .sort_by { |relic| Relic.deep_dungeon_weapon_ids.index(relic.id) }
    @eureka_physeos_weapons = Relic.where(id: Relic.eureka_physeos_weapon_ids)
  end

  def tools
    @lucis_tools = Relic.where(id: Relic.lucis_tool_ids)
    @skysteel_tools = Relic.where(id: Relic.skysteel_tool_ids)
    @resplendent_tools = Relic.where(id: Relic.resplendent_tool_ids)
  end

  def armor
    @eureka_job_armor = ["Eureka Anemos Armor", "Eureka Job Armor +2", "Eureka Job Armor +1", "Eureka Job Armor"]
      .zip(Relic.where(id: Relic.eureka_job_armor_ids).each_slice(75).to_a.reverse).to_h
    @eureka_elemental_armor = ['Elemental Armor +2', 'Elemental Armor +1', 'Elemental Armor']
      .zip(Relic.where(id: Relic.eureka_elemental_armor_ids).each_slice(35).to_a.reverse).to_h
    @idealized_armor = Relic.where(id: Relic.idealized_armor_ids)
    @bozjan_armor = ["Blade's Armor", "Augmented Law's Order", "Law's Order", 'Augmented Bozjan Armor', 'Bozjan Armor',]
      .zip(Relic.where(id: Relic.bozjan_armor_ids).each_slice(35).to_a.reverse).to_h
  end

  def add
    add_collectable(@character.relics, Relic.find(params[:id]))
  end

  def remove
    remove_collectable(@character.relics, params[:id])
  end

  private
  def set_relic_collection!
    @collection_ids = @character&.relic_ids || []
    @owned = Redis.current.hgetall('relics')
    @dates = @character&.character_relics&.pluck('relic_id', :created_at).to_h || {}
  end
end

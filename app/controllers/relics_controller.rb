class RelicsController < ApplicationController
  include ManualCollection
  before_action :check_achievements!, only: :weapons
  before_action :display_verify_alert!, only: [:manual_weapons, :tools, :armor]
  before_action :set_item_collection!, only: [:manual_weapons, :tools, :armor]
  skip_before_action :display_verify_alert!, only: :weapons
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def weapons
    @anima_weapons = AchievementCategory.find_by(name_en: 'Anima Weapons').achievements.order(:order)
    @eureka_weapons = AchievementCategory.find_by(name_en: 'Eureka Weapons').achievements.order(:order)
    @resistance_weapons = AchievementCategory.find_by(name_en: 'Resistance Weapons').achievements.order(:order)
    @collection_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall('achievements')
    @dates = @character&.character_achievements&.pluck('achievement_id', :created_at).to_h || {}
  end

  def manual_weapons
    @arr_relic_weapons = Item.where(id: Item.arr_relic_weapon_ids)
      .sort_by { |item| Item.arr_relic_weapon_ids.index(item.id) }
    @deep_dungeon_weapons = Item.where(id: Item.deep_dungeon_weapon_ids)
      .sort_by { |item| Item.deep_dungeon_weapon_ids.index(item.id) }
    @eureka_physeos_weapons = Item.where(id: Item.eureka_physeos_weapon_ids)
  end

  def tools
    @lucis_tools = Item.where(id: Item.lucis_tool_ids)
    @skysteel_tools = Item.where(id: Item.skysteel_tool_ids)
  end

  def armor
    @eureka_job_armor = [t('general.eureka_anemos_armor'), "#{t('general.eureka_job_armor')} +2", "#{t('general.eureka_job_armor')} +1", t('general.eureka_job_armor')]
      .zip(Item.where(id: Item.eureka_job_armor_ids).each_slice(75).to_a.reverse).to_h
    @eureka_elemental_armor = ["#{t('general.elemental_armor')} +2", "#{t('general.elemental_armor')}  +1", t('general.elemental_armor')]
      .zip(Item.where(id: Item.eureka_elemental_armor_ids).each_slice(35).to_a.reverse).to_h
    @idealized_armor = Item.where(id: Item.idealized_armor_ids)
    @bozjan_armor = [t('general.augmented_bozjan_armor'), t('general.bozjan_armor')]
      .zip(Item.where(id: Item.bozjan_armor_ids).each_slice(35).to_a.reverse).to_h
  end

  private
  def set_item_collection!
    @collection_ids = @character&.item_ids || []
    @owned = Redis.current.hgetall('items')
    @dates = @character&.character_items&.pluck('item_id', :created_at).to_h || {}
  end
end

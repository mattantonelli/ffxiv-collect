class RelicsController < ApplicationController
  include ManualCollection
  before_action :check_achievements!, only: :weapons
  skip_before_action :display_verify_alert!, only: :weapons
  before_action :display_verify_alert!, only: :tools
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def weapons
    @relic_weapons = AchievementCategory.find_by(name_en: 'Relic Weapons').achievements.order(:order).first(10)
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

    @collection_ids = @character&.item_ids || []
    @owned = Redis.current.hgetall('items')
    @dates = @character&.character_items&.pluck('item_id', :created_at).to_h || {}
  end
end

require 'ostruct'

class RelicsController < ApplicationController
  include ManualCollection
  include PrivateCollection

  before_action -> { check_lodestone_privacy!(:achievements) }, only: [:weapons, :tools, :garo]
  before_action :display_verify_alert!, only: [:weapons, :ultimate, :tools, :armor, :garo]
  before_action :set_relic_collection!, only: [:weapons, :ultimate, :tools, :armor, :garo]
  skip_before_action :set_owned!, :set_ids!, :set_dates!, :set_prices!

  def weapons
    @types = RelicType.includes(:relics).where(category: 'weapons').order(order: :desc)
  end

  def ultimate
    @types = RelicType.includes(:relics).where(category: 'ultimate').order(order: :desc)
  end

  def tools
    @types = RelicType.includes(:relics).where(category: 'tools').order(order: :desc)
  end

  def armor
    @types = RelicType.includes(:relics).where(category: 'armor').order(expansion: :desc, order: :desc)
    @categories = @types.pluck(:expansion).uniq.sort.map do |expansion|
      OpenStruct.new(id: expansion, name: t("expansions.#{expansion}"))
    end
  end

  def garo
    @weapons = RelicType.includes(:relics).find_by(name_en: 'GARO Weapons')
    @armor = RelicType.includes(:relics).find_by(name_en: 'GARO Armor')
    @mounts = Mount.includes(:sources).where(id: [95, 96, 102]).order(:order)
    @mount_ids = @character&.mount_ids || []
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
    @achievement_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall('relics')
    @dates = @character&.character_relics&.pluck('relic_id', :created_at).to_h || {}
  end
end

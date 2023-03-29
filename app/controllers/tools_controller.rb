class ToolsController < ApplicationController
  include Collection
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def gemstones
    find_collectables_by_source!('Bicolor Gemstone')
  end

  def market_board
    # Fetch all of the item prices from Redis
    data_center = @character&.data_center&.downcase || 'primal'
    @prices = Redis.current.hgetall("prices-#{data_center}").each_with_object({}) do |(id, price), h|
      h[id.to_i] = JSON.parse(price, symbolize_names: true)
    end

    # Create a numeric order of prices by adding the item ID to the price data, sorting, and extracting it
    @price_order = @prices.map { |id, data| data.merge(id: id) }
      .sort_by { |item| item[:price] == 'N/A' ? 9999999999 : item[:price] }
      .pluck(:id)

    # Collect all of the tradeable collectables through their Item association and sort them by price
    @items = Item.collectable.tradeable.includes(unlock: { sources: [:type, :related] })
      .to_a.sort_by { |item| @price_order.index(item.id) || 9999 }

    # Collect the relevant IDs of collectables owned by the player
    if @character.present?
      @owned_ids = Item.collectable.tradeable.pluck(:unlock_type).uniq.each_with_object({}) do |type, h|
        h[type.downcase.pluralize.to_sym] = @character.send("#{type.downcase}_ids")
      end
    end
  end

  def materiel
    @containers = (3..4).each_with_object({}) do |number, h|
      h[number] = {
        mounts: Mount.materiel_container(number).ordered,
        minions: Minion.materiel_container(number).ordered
      }
    end

    if @character.present?
      @owned_ids = {
        mounts: @character.mount_ids,
        minions: @character.minion_ids
      }
    end
  end

  def treasure
    find_collectables_by_source!(Source.treasure_hunts)
  end

  private
  def find_collectables_by_source!(sources)
    text = [*sources].join('|')

    @collectables = Source.where('text regexp ?', text)
      .each_with_object(Hash.new { |h, k| h[k] = [] }) do |source, h|
        h[source.collectable_type.downcase.pluralize.to_sym] << source.collectable_id
      end

    @collectables.each do |type, ids|
      model = type.to_s.classify.constantize
      @collectables[type] = model.where(id: ids).include_sources
    end

    if @character.present?
      @owned_ids = @collectables.keys.each_with_object({}) do |type, h|
        h[type] = @character.send("#{type.to_s.downcase.singularize}_ids")
      end
    end
  end

  def verify_character_selected!
    unless @character.present?
      flash[:error] = t('alerts.character_not_selected')
      redirect_to root_path
    end
  end
end

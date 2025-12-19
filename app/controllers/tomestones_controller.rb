class TomestonesController < ApplicationController
  include PrivateCollection
  include TomestonesHelper

  before_action -> { check_privacy!(:mounts, :minions) }
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    if @character.present?
      @owned_ids = TomestoneReward.collectables.pluck(:collectable_type).uniq.each_with_object({}) do |type, h|
        h[type.downcase.pluralize.to_sym] =
          "Character#{type}".constantize.where(character: @character).pluck("#{type.downcase}_id")
      end
    end

    @tomestones = Item.where('name_en like ?', 'Irregular Tomestone%').order(:created_at)

    if params[:action] == 'index'
      @tomestone = @tomestones.last.tomestone_name(locale: I18n.locale)
    else
      item = Item.find_by(name_en: "Irregular Tomestone Of #{params[:id]}")
      @tomestone = item&.tomestone_name(locale: I18n.locale) || params[:id].titleize
    end

    @title = "#{t('tomestones.title')}: #{@tomestone}"
    @collectables = collectables(@tomestone)
    @items = items(@tomestone)
  end

  # Leverage ID param to dynamically route to tomestone rewards by name
  def show
    index
    render :index
  end

  private
  def collectables(tomestone)
    TomestoneReward.collectables.where(tomestone: tomestone).include_related.ordered
  end

  def items(tomestone)
    TomestoneReward.items.where(tomestone: tomestone).include_related.ordered
  end
end

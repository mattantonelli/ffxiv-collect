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

    @tomestones = Item.where('name_en like ?', 'Irregular Tomestone%')
      .where('name_en regexp ?', TomestoneReward.pluck(:tomestone).uniq.join('|'))
      .order(:created_at)

    if params[:action] == 'index'
      @tomestone = @tomestones.last
    else
      @tomestone = Item.find_by(name_en: "Irregular Tomestone Of #{params[:id]}")
    end

    @title = "#{t('tomestones.page_title', name: @tomestone.tomestone_name(locale: I18n.locale))}"
    @collectables = collectables(@tomestone.tomestone_name)
    @items = items(@tomestone.tomestone_name)
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

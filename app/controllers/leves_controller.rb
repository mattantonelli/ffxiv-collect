class LevesController < ApplicationController
  include ManualCollection

  before_action :display_verify_alert!, only: [:battlecraft, :tradecraft, :fieldcraft]

  def index
    @leves = Leve.where(craft: @craft).include_related.ordered

    @categories = @leves.pluck(:category).uniq.map do |category|
      t("leves.categories.#{category.parameterize.underscore}")
    end

    @categories.unshift(nil) # Workaround for category buttons expecting the first category to be "All"
    @category = params[:category].to_i
    @category = 1 if @category < 1

    render :index
  end

  def battlecraft
    @craft = 'Battlecraft'
    index
  end

  def tradecraft
    @craft = 'Tradecraft'
    index
  end

  def fieldcraft
    @craft = 'Fieldcraft'
    index
  end

  def add
    add_collectable(@character.leves, Leve.find(params[:id]))
  end

  def remove
    remove_collectable(@character.leves, params[:id])
  end
end

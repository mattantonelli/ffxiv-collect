class SpellsController < ApplicationController
  include ManualCollection

  def index
    @q = Spell.ransack(params[:q])
    @spells = @q.result.includes(:type, :aspect).include_sources.with_filters(cookies).order(:order).distinct
    @aspects = SpellAspect.all.order("name_#{I18n.locale}").pluck("name_#{I18n.locale}").uniq
  end

  def show
    @spell = Spell.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.spells, Spell.find(params[:id]))
  end

  def remove
    remove_collectable(@character.spells, params[:id])
  end
end

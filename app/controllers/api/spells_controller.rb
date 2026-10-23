class Api::SpellsController < ApiController
  def index
    query = Spell.all.ransack(@query)
    @spells = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @spell = Spell.include_sources.find(params[:id])
  end
end

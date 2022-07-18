class Api::SpellsController < ApiController
  def index
    query = Spell.all.ransack(@query)
    @spells = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @spell = Spell.include_sources.find_by(id: params[:id])
    render_not_found unless @spell.present?
  end
end

class Api::SpellsController < ApiController
  def index
    query = Spell.all.ransack(@query)
    @spells = query.result.includes(:type, :aspect).include_sources
      .order(:order).distinct.limit(params[:limit])
    @owned = Redis.current.hgetall(:spells)
  end

  def show
    @spell = Spell.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:spells, params[:id]) }
    render_not_found unless @spell.present?
  end
end

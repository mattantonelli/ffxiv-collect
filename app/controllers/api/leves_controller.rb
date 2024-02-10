class Api::LevesController < ApiController
  def index
    query = Leve.all.ransack(@query)
    @leves = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @leve = Leve.find_by(id: params[:id])
    render_not_found unless @leve.present?
  end
end

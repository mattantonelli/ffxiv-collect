class Api::LevesController < ApiController
  def index
    query = Leve.all.ransack(@query)
    @leves = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @leve = Leve.find(params[:id])
  end
end

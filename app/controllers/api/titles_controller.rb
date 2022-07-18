class Api::TitlesController < ApiController
  def index
    query = Title.include_related.all.ransack(@query)
    @titles = query.result.ordered.distinct.limit(params[:limit])
  end

  def show
    @title = Title.find_by(id: params[:id])
    render_not_found unless @title.present?
  end
end

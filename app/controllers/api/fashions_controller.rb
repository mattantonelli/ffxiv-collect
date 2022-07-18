class Api::FashionsController < ApiController
  def index
    query = Fashion.all.ransack(@query)
    @fashions = query.result.include_sources
      .order(patch: :desc, order: :desc).distinct.limit(params[:limit])
  end

  def show
    @fashion = Fashion.include_sources.find_by(id: params[:id])
    render_not_found unless @fashion.present?
  end
end

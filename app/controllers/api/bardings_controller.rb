class Api::BardingsController < ApiController
  def index
    query = Barding.all.ransack(@query)
    @bardings = query.result.include_sources.order(patch: :desc, order: :desc)
      .distinct.limit(params[:limit])
  end

  def show
    @barding = Barding.include_sources.find_by(id: params[:id])
    render_not_found unless @barding.present?
  end
end

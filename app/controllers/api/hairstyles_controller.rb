class Api::HairstylesController < ApiController
  def index
    query = Hairstyle.all.ransack(@query)
    @hairstyles = query.result.include_sources.order(patch: :desc, id: :desc).distinct.limit(params[:limit])
  end

  def show
    @hairstyle = Hairstyle.include_sources.find_by(id: params[:id])
    render_not_found unless @hairstyle.present?
  end
end

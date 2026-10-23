class Api::HairstylesController < ApiController
  def index
    query = Hairstyle.all.ransack(@query)
    @hairstyles = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @hairstyle = Hairstyle.include_sources.find(params[:id])
  end
end

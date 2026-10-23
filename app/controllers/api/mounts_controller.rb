class Api::MountsController < ApiController
  def index
    query = Mount.all.ransack(@query)
    @mounts = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @mount = Mount.include_sources.find(params[:id])
  end
end

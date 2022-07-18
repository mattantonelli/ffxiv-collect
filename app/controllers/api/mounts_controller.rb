class Api::MountsController < ApiController
  def index
    query = Mount.all.ransack(@query)
    @mounts = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @mount = Mount.include_sources.find_by(id: params[:id])
    render_not_found unless @mount.present?
  end
end

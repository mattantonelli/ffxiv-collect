class Api::RecordsController < ApiController
  def index
    query = Record.all.ransack(@query)
    @records = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @record = Record.include_sources.find_by(id: params[:id])
    render_not_found unless @record.present?
  end
end

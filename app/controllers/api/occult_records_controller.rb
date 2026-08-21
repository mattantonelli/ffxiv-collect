class Api::OccultRecordsController < ApiController
  def index
    query = OccultRecord.all.ransack(@query)
    @occult_records = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @occult_record = OccultRecord.include_sources.find_by(id: params[:id])
    render_not_found unless @occult_record.present?
  end
end

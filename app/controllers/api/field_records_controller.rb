class Api::FieldRecordsController < ApiController
  def index
    query = FieldRecord.all.ransack(@query)
    @field_records = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @field_record = FieldRecord.include_sources.find(params[:id])
  end
end

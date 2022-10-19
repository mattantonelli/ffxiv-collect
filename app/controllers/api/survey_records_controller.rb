class Api::SurveyRecordsController < ApiController
  def index
    query = SurveyRecord.all.ransack(@query)
    @records = query.result.include_related.ordered.limit(params[:limit])
  end

  def show
    @record = SurveyRecord.find_by(id: params[:id])
    render_not_found unless @record.present?
  end
end

class Api::SurveyRecordsController < ApiController
  def index
    query = SurveyRecord.all.ransack(@query)
    @survey_records = query.result.include_related.ordered.limit(params[:limit])
  end

  def show
    @survey_record = SurveyRecord.find_by(id: params[:id])
    render_not_found unless @survey_record.present?
  end
end

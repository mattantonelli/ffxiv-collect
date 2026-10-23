class Api::SurveyRecordsController < ApiController
  def index
    query = SurveyRecord.all.ransack(@query)
    @survey_records = query.result.available.include_related.ordered.limit(params[:limit])
  end

  def show
    @survey_record = SurveyRecord.find(params[:id])
  end
end

class SurveyRecordsController < ApplicationController
  include ManualCollection
  skip_before_action :set_prices!

  def index
    @category = params[:category].to_i
    @category = nil if @category < 1
    @categories = SurveyRecordSeries.ordered
    @records = SurveyRecord.ordered.include_related
  end

  def show
    @record = SurveyRecord.find(params[:id])
  end

  def add
    add_collectable(@character.survey_records, SurveyRecord.find(params[:id]))
  end

  def remove
    remove_collectable(@character.survey_records, params[:id])
  end
end

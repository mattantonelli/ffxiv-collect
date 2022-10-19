class SurveyRecordsController < ApplicationController
  include ManualCollection
  skip_before_action :set_prices!

  def index
    @records = SurveyRecord.order(:series_id, :id).includes(:series)
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

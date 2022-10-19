# == Schema Information
#
# Table name: survey_record_series
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)
#  name_de    :string(255)
#  name_fr    :string(255)
#  name_ja    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SurveyRecordSeries < ApplicationRecord
  has_many :records, class_name: 'SurveyRecord', foreign_key: 'series_id'
  translates :name, :description
end

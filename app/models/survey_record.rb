# == Schema Information
#
# Table name: survey_records
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)
#  name_de        :string(255)
#  name_fr        :string(255)
#  name_ja        :string(255)
#  description_en :text(65535)
#  description_de :text(65535)
#  description_fr :text(65535)
#  description_ja :text(65535)
#  solution       :string(1000)
#  patch          :string(255)
#  series_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class SurveyRecord < ApplicationRecord
  include Collectable

  belongs_to :series, class_name: 'SurveyRecordSeries'
  translates :name, :description

  scope :include_related, -> { includes(:series) }
  scope :ordered, -> { order(:id) }
end

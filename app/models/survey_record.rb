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
#  solution_en    :string(1000)
#  patch          :string(255)
#  series_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order          :integer
#  solution_de    :string(1000)
#  solution_fr    :string(1000)
#  solution_ja    :string(1000)
#
class SurveyRecord < ApplicationRecord
  include Collectable

  belongs_to :series, class_name: 'SurveyRecordSeries', required: false
  translates :name, :description, :solution

  alias_method :category, :series
  alias_attribute :category_id, :series_id

  scope :include_related, -> { includes(:series) }
  scope :ordered, -> { order({ series_id: :desc }, :order) }

  def self.available_filters
    %i(owned)
  end
end

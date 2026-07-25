# == Schema Information
#
# Table name: character_survey_records
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  character_id     :integer
#  survey_record_id :integer
#
class CharacterSurveyRecord < ApplicationRecord
  belongs_to :character, counter_cache: :survey_records_count, touch: true
  belongs_to :survey_record
end

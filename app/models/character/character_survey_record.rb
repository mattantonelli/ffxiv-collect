# == Schema Information
#
# Table name: character_survey_records
#
#  id               :bigint(8)        not null, primary key
#  character_id     :integer
#  survey_record_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class CharacterSurveyRecord < ApplicationRecord
  belongs_to :character, counter_cache: :survey_records_count, touch: true
  belongs_to :survey_record
end

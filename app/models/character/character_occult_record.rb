# == Schema Information
#
# Table name: character_occult_records
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  character_id     :integer
#  occult_record_id :integer
#
class CharacterOccultRecord < ApplicationRecord
  belongs_to :character, counter_cache: :occult_records_count, touch: true
  belongs_to :occult_record
end

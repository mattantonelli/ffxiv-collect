# == Schema Information
#
# Table name: character_occult_records
#
#  id               :bigint(8)        not null, primary key
#  character_id     :integer
#  occult_record_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class CharacterOccultRecord < ApplicationRecord
  belongs_to :character, counter_cache: :occult_records_count, touch: true
  belongs_to :occult_record
end

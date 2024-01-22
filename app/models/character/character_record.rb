# == Schema Information
#
# Table name: character_records
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  record_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CharacterRecord < ApplicationRecord
  belongs_to :character, counter_cache: :records_count, touch: true
  belongs_to :record
end

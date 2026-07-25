# == Schema Information
#
# Table name: character_field_records
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  character_id    :integer
#  field_record_id :integer
#
class CharacterFieldRecord < ApplicationRecord
  belongs_to :character, counter_cache: :field_records_count, touch: true
  belongs_to :field_record
end

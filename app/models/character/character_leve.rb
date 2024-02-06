# == Schema Information
#
# Table name: character_leves
#
#  id           :bigint(8)        not null, primary key
#  leve_id      :integer
#  character_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterLeve < ApplicationRecord
  belongs_to :character, counter_cache: :leves_count, touch: true
  belongs_to :leve
end

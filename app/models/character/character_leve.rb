# == Schema Information
#
# Table name: character_leves
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  leve_id      :integer
#

class CharacterLeve < ApplicationRecord
  belongs_to :character, counter_cache: :leves_count, touch: true
  belongs_to :leve
end

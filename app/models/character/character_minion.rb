# == Schema Information
#
# Table name: character_minions
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  minion_id    :integer
#

class CharacterMinion < ApplicationRecord
  belongs_to :character, counter_cache: :minions_count, touch: true
  belongs_to :minion
end

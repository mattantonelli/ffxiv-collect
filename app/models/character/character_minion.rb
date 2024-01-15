# == Schema Information
#
# Table name: character_minions
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  minion_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterMinion < ApplicationRecord
  belongs_to :character, counter_cache: :minions_count, touch: true
  belongs_to :minion
end

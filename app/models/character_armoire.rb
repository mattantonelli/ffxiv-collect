# == Schema Information
#
# Table name: character_armoires
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  armoire_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterArmoire < ApplicationRecord
  belongs_to :character, counter_cache: :armoires_count, touch: true
  belongs_to :armoire
end

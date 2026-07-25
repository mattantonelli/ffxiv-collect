# == Schema Information
#
# Table name: character_armoires
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  armoire_id   :integer
#  character_id :integer
#

class CharacterArmoire < ApplicationRecord
  belongs_to :character, counter_cache: :armoires_count, touch: true
  belongs_to :armoire
end

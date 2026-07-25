# == Schema Information
#
# Table name: character_npcs
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  npc_id       :integer
#

class CharacterNPC < ApplicationRecord
  belongs_to :character, counter_cache: :npcs_count, touch: true
  belongs_to :npc
end

# == Schema Information
#
# Table name: character_npcs
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  npc_id       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterNPC < ApplicationRecord
  belongs_to :character, counter_cache: :npcs_count, touch: true
  belongs_to :npc
end

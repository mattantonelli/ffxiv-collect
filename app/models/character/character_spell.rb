# == Schema Information
#
# Table name: character_spells
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  spell_id     :integer
#

class CharacterSpell < ApplicationRecord
  belongs_to :character, counter_cache: :spells_count, touch: true
  belongs_to :spell
end

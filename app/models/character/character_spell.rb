# == Schema Information
#
# Table name: character_spells
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  spell_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterSpell < ApplicationRecord
  belongs_to :character, counter_cache: :spells_count, touch: true
  belongs_to :spell
end

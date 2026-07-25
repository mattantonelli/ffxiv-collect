# == Schema Information
#
# Table name: character_cards
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  card_id      :integer
#  character_id :integer
#

class CharacterCard < ApplicationRecord
  belongs_to :character, counter_cache: :cards_count, touch: true
  belongs_to :card
end

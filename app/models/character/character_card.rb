# == Schema Information
#
# Table name: character_cards
#
#  id           :bigint(8)        not null, primary key
#  card_id      :integer
#  character_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterCard < ApplicationRecord
  belongs_to :character, counter_cache: :cards_count, touch: true
  belongs_to :card
end

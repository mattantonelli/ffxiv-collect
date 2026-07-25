# == Schema Information
#
# Table name: deck_cards
#
#  id         :bigint           not null, primary key
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :integer
#  deck_id    :integer
#

class DeckCard < ApplicationRecord
  belongs_to :deck
  belongs_to :card

  # default_scope { order(:position) }
end

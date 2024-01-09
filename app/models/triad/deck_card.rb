# == Schema Information
#
# Table name: deck_cards
#
#  id         :bigint(8)        not null, primary key
#  deck_id    :integer
#  card_id    :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DeckCard < ApplicationRecord
  belongs_to :deck
  belongs_to :card

  # default_scope { order(:position) }
end

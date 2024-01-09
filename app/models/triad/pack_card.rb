# == Schema Information
#
# Table name: pack_cards
#
#  id         :bigint(8)        not null, primary key
#  pack_id    :integer          not null
#  card_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PackCard < ApplicationRecord
  belongs_to :pack
  belongs_to :card
end

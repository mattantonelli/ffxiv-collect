# == Schema Information
#
# Table name: pack_cards
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :integer          not null
#  pack_id    :integer          not null
#

class PackCard < ApplicationRecord
  belongs_to :pack
  belongs_to :card
end

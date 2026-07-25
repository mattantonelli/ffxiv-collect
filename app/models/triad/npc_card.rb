# == Schema Information
#
# Table name: npc_cards
#
#  id         :bigint           not null, primary key
#  fixed      :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :integer          not null
#  npc_id     :integer          not null
#

class NPCCard < ApplicationRecord
  belongs_to :npc
  belongs_to :card
end

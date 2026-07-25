# == Schema Information
#
# Table name: npc_rewards
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :integer          not null
#  npc_id     :integer          not null
#

class NPCReward < ApplicationRecord
  belongs_to :npc
  belongs_to :card
end

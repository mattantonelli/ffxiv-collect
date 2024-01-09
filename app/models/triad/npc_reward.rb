# == Schema Information
#
# Table name: npc_rewards
#
#  id         :bigint(8)        not null, primary key
#  npc_id     :integer          not null
#  card_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NPCReward < ApplicationRecord
  belongs_to :npc
  belongs_to :card
end

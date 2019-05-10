# == Schema Information
#
# Table name: character_orchestrions
#
#  id             :bigint(8)        not null, primary key
#  character_id   :integer
#  orchestrion_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CharacterOrchestrion < ApplicationRecord
  belongs_to :character, counter_cache: :orchestrions_count
  belongs_to :orchestrion
end

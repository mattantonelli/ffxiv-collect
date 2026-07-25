# == Schema Information
#
# Table name: character_orchestrions
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  character_id   :integer
#  orchestrion_id :integer
#

class CharacterOrchestrion < ApplicationRecord
  belongs_to :character, counter_cache: :orchestrions_count, touch: true
  belongs_to :orchestrion
end

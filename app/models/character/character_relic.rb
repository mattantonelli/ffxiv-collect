# == Schema Information
#
# Table name: character_relics
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  relic_id     :integer
#
class CharacterRelic < ApplicationRecord
  belongs_to :character, counter_cache: :relics_count, touch: true
  belongs_to :relic
end

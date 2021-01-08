# == Schema Information
#
# Table name: character_relics
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  relic_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CharacterRelic < ApplicationRecord
  belongs_to :character, counter_cache: :relics_count, touch: true
  belongs_to :relic
end

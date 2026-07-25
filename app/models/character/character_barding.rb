# == Schema Information
#
# Table name: character_bardings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  barding_id   :integer
#  character_id :integer
#

class CharacterBarding < ApplicationRecord
  belongs_to :character, counter_cache: :bardings_count, touch: true
  belongs_to :barding
end

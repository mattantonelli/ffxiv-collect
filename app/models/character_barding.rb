# == Schema Information
#
# Table name: character_bardings
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  barding_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterBarding < ApplicationRecord
  belongs_to :character, counter_cache: :bardings_count
  belongs_to :barding
end

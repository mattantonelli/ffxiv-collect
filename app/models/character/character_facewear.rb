# == Schema Information
#
# Table name: character_facewear
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  facewear_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterFacewear < ApplicationRecord
  belongs_to :character, counter_cache: :facewear_count, touch: true
  belongs_to :facewear
end

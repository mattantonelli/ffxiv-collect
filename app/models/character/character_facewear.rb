# == Schema Information
#
# Table name: character_facewear
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  facewear_id  :integer
#

class CharacterFacewear < ApplicationRecord
  belongs_to :character, counter_cache: :facewear_count, touch: true
  belongs_to :facewear
end

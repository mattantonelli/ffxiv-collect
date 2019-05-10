# == Schema Information
#
# Table name: character_hairstyles
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  hairstyle_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterHairstyle < ApplicationRecord
  belongs_to :character, counter_cache: :hairstyles_count
  belongs_to :hairstyle
end

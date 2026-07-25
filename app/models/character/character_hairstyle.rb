# == Schema Information
#
# Table name: character_hairstyles
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  hairstyle_id :integer
#

class CharacterHairstyle < ApplicationRecord
  belongs_to :character, counter_cache: :hairstyles_count, touch: true
  belongs_to :hairstyle
end

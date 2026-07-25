# == Schema Information
#
# Table name: character_fashions
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  fashion_id   :integer
#
class CharacterFashion < ApplicationRecord
  belongs_to :character, counter_cache: :fashions_count, touch: true
  belongs_to :fashion
end

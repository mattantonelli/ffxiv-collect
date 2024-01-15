# == Schema Information
#
# Table name: character_fashions
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  fashion_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CharacterFashion < ApplicationRecord
  belongs_to :character, counter_cache: :fashions_count, touch: true
  belongs_to :fashion
end

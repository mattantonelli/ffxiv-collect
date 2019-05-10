# == Schema Information
#
# Table name: character_achievements
#
#  id             :bigint(8)        not null, primary key
#  character_id   :integer
#  achievement_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CharacterAchievement < ApplicationRecord
  belongs_to :character, counter_cache: :achievements_count
  belongs_to :achievement
end

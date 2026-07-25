# == Schema Information
#
# Table name: character_achievements
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  achievement_id :integer
#  character_id   :integer
#

class CharacterAchievement < ApplicationRecord
  belongs_to :character, counter_cache: :achievements_count, touch: true
  belongs_to :achievement
end

# == Schema Information
#
# Table name: character_frames
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  frame_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterFrame < ApplicationRecord
  belongs_to :character, counter_cache: :frames_count, touch: true
  belongs_to :frame
end

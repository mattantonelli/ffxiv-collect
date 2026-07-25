# == Schema Information
#
# Table name: character_frames
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  frame_id     :integer
#

class CharacterFrame < ApplicationRecord
  belongs_to :character, counter_cache: :frames_count, touch: true
  belongs_to :frame
end

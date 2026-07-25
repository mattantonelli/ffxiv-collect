# == Schema Information
#
# Table name: character_mounts
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  mount_id     :integer
#

class CharacterMount < ApplicationRecord
  belongs_to :character, counter_cache: :mounts_count, touch: true
  belongs_to :mount
end

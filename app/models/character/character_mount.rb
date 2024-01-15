# == Schema Information
#
# Table name: character_mounts
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  mount_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterMount < ApplicationRecord
  belongs_to :character, counter_cache: :mounts_count, touch: true
  belongs_to :mount
end

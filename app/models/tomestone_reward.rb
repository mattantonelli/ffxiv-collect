# == Schema Information
#
# Table name: tomestone_rewards
#
#  id               :bigint(8)        not null, primary key
#  cost             :integer
#  collectable_id   :integer
#  collectable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TomestoneReward < ApplicationRecord
  belongs_to :collectable, polymorphic: true
end

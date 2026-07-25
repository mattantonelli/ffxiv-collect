# == Schema Information
#
# Table name: group_memberships
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  group_id     :integer
#
class GroupMembership < ApplicationRecord
  belongs_to :group
  belongs_to :character
  validates_uniqueness_of :character, scope: :group
end

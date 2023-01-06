# == Schema Information
#
# Table name: group_memberships
#
#  id           :bigint(8)        not null, primary key
#  group_id     :integer
#  character_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class GroupMembership < ApplicationRecord
  belongs_to :group
  belongs_to :character
  validates_uniqueness_of :character, scope: :group
end

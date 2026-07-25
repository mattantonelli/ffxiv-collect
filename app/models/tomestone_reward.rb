# == Schema Information
#
# Table name: tomestone_rewards
#
#  id               :bigint           not null, primary key
#  collectable_type :string(255)
#  cost             :integer
#  tomestone        :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  collectable_id   :integer
#

class TomestoneReward < ApplicationRecord
  belongs_to :collectable, polymorphic: true

  scope :include_related, -> { includes(collectable: { sources: [:type, :related] }) }
  scope :ordered, -> { order(cost: :desc) }
  scope :collectables, -> { where.not(collectable_type: 'Item') }
  scope :items, -> { where(collectable_type: 'Item') }

  # TODO: Migrate the tomestone string foreign key to a proper item_id
end

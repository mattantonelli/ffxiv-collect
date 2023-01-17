# == Schema Information
#
# Table name: frames
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  patch      :string(255)
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Frame < ApplicationRecord
  include Collectable
  translates :name, :description

  scope :include_related, -> { includes(:item).include_sources }
  scope :ordered, -> { order(patch: :desc, id: :desc) }

  belongs_to :item
  delegate :description, to: :item
  delegate :name, to: :item, prefix: :item
end

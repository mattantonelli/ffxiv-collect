# == Schema Information
#
# Table name: frames
#
#  id            :bigint(8)        not null, primary key
#  name_en       :string(255)      not null
#  name_de       :string(255)      not null
#  name_fr       :string(255)      not null
#  name_ja       :string(255)      not null
#  patch         :string(255)
#  item_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order         :integer
#  portrait_only :boolean          default(FALSE)
#
class Frame < ApplicationRecord
  include Collectable
  translates :name, :description

  scope :include_related, -> { includes(:item).include_sources }
  scope :ordered, -> { order(patch: :desc, order: :asc) }

  belongs_to :item, required: false
  delegate :description, to: :item, allow_nil: true
  delegate :name, to: :item, prefix: :item, allow_nil: true

  def tradeable?
    false
  end

  def self.available_filters
    %i(owned premium limited ranked_pvp unknown)
  end
end

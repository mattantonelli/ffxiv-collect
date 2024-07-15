# == Schema Information
#
# Table name: facewear
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  order      :integer          not null
#  patch      :string(255)
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Facewear < ApplicationRecord
  include Collectable
  translates :name

  scope :include_related, -> { include_sources }
  scope :ordered, -> { order(patch: :desc, order: :desc) }

  def reclaimable?
    id < 5
  end

  def self.available_filters
    %i(owned tradeable limited ranked_pvp unknown)
  end
end

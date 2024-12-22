# == Schema Information
#
# Table name: outfits
#
#  id          :bigint(8)        not null, primary key
#  name_en     :string(255)      not null
#  name_de     :string(255)      not null
#  name_fr     :string(255)      not null
#  name_ja     :string(255)      not null
#  armoireable :boolean          default(FALSE)
#  gender      :string(255)
#  patch       :string(255)
#  item_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Outfit < ApplicationRecord
  include Collectable
  translates :name

  scope :include_related, -> { include_sources.includes(:items) }
  scope :ordered, -> { order(patch: :desc, id: :desc) }

  # The items that comprise the outfit
  has_many :outfit_items, dependent: :delete_all
  has_many :items, through: :outfit_items

  def self.available_filters
    %i(owned tradeable premium limited unknown)
  end
end

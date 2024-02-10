# == Schema Information
#
# Table name: leves
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  craft          :string(255)      not null
#  category       :string(255)      not null
#  level          :integer          not null
#  location_id    :integer          not null
#  issuer_name_en :string(255)      not null
#  issuer_name_de :string(255)      not null
#  issuer_name_fr :string(255)      not null
#  issuer_name_ja :string(255)      not null
#  issuer_x       :decimal(3, 1)    not null
#  issuer_y       :decimal(3, 1)    not null
#  item_id        :integer
#  item_quantity  :integer
#  patch          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Leve < ApplicationRecord
  include Collectable
  translates :name, :issuer_name

  belongs_to :item, optional: true
  belongs_to :location

  scope :include_related, -> { includes(:location, :item) }
  scope :ordered, -> { order(:craft, :category, :level, "locations.name_#{I18n.locale} ASC",
                             "leves.name_#{I18n.locale} ASC") }

  def self.available_filters
    %i(owned)
  end

  def self.crafts
    %w(battlecraft tradecraft fieldcraft)
  end
end

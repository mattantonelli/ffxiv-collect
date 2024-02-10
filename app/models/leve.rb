# == Schema Information
#
# Table name: leves
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  category_id    :integer          not null
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
#  limited        :boolean          default(FALSE)
#
class Leve < ApplicationRecord
  include Collectable
  translates :name, :issuer_name

  belongs_to :item, optional: true
  belongs_to :location
  belongs_to :category, class_name: 'LeveCategory'
  delegate :craft, to: :category

  scope :include_related, -> { includes(:category, :location, :item) }
  scope :ordered, -> { order("leve_categories.craft_#{I18n.locale}", "leve_categories.order", :level, :id) }

  scope :hide_limited, -> (hide) do
    where('leves.limited = FALSE') if hide
  end

  def self.available_filters
    %i(owned limited)
  end
end

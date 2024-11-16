# == Schema Information
#
# Table name: armoires
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  order          :integer          not null
#  patch          :string(255)
#  category_id    :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  gender         :string(255)
#  description_en :string(255)
#  description_de :string(255)
#  description_fr :string(255)
#  description_ja :string(255)
#  item_id        :integer          not null
#  order_group    :integer
#

class Armoire < ApplicationRecord
  include Collectable
  translates :name, :description
  belongs_to :category, class_name: 'ArmoireCategory'
  belongs_to :item

  scope :include_related, -> { include_sources.includes(:category, :item) }
  scope :ordered, -> { order(patch: :desc, order_group: :desc, order: :desc) }

  def tradeable?
    false
  end

  def self.available_filters
    %i(owned gender premium limited unknown)
  end
end

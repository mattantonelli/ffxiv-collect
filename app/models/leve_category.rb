# == Schema Information
#
# Table name: leve_categories
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  craft_en   :string(255)      not null
#  craft_de   :string(255)      not null
#  craft_fr   :string(255)      not null
#  craft_ja   :string(255)      not null
#  order      :integer          not null
#  items      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LeveCategory < ApplicationRecord
  self.table_name = 'leve_categories'

  translates :name, :craft

  has_many :leves, foreign_key: 'category_id'

  scope :ordered, -> { order(:order) }

  def self.crafts
    %w(battlecraft tradecraft fieldcraft)
  end
end

# == Schema Information
#
# Table name: achievement_types
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order      :integer
#

class AchievementType < ApplicationRecord
  has_many :categories, class_name: 'AchievementCategory', foreign_key: 'type_id'
  has_many :achievements, through: :categories

  translates :name

  scope :ordered, -> { order(:order) }
  scope :with_filters, -> (filters) do
    if filters[:limited] == 'hide'
      where.not(name_en: 'Legacy')
    end
  end
end

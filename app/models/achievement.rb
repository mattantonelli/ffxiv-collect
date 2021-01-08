# == Schema Information
#
# Table name: achievements
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  description_en :string(255)      not null
#  description_de :string(255)      not null
#  description_fr :string(255)      not null
#  description_ja :string(255)      not null
#  points         :integer          not null
#  order          :integer          not null
#  patch          :string(255)
#  category_id    :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  icon_id        :integer
#

class Achievement < ApplicationRecord
  after_save :touch_title

  belongs_to :category, class_name: 'AchievementCategory'
  belongs_to :item
  has_one :title, required: false
  has_many :character_achievements
  has_many :characters, through: :character_achievements

  delegate :type, to: :category

  translates :name, :description, :item_name

  scope :exclude_time_limited, -> do
    joins(category: :type)
      .where('achievement_types.name_en <> ?', 'Legacy')
      .where('achievement_categories.name_en <> ?', 'Seasonal Events')
  end

  scope :with_filters, -> (filters, character = nil) do
    if filters[:limited] == 'hide'
      exclude_time_limited
    end
  end

  private
  def touch_title
    title&.update_column(:updated_at, Time.now)
  end
end

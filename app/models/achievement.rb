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
  belongs_to :item, required: false
  has_one :title, required: false
  has_many :character_achievements
  has_many :characters, through: :character_achievements
  has_many :relics

  delegate :type, to: :category

  translates :name, :description, :item_name

  scope :exclude_time_limited, -> do
    joins(category: :type)
      .where('achievement_types.name_en <> ?', 'Legacy')
      .where('achievement_categories.name_en <> ?', 'Seasonal Events')
      .where.not('achievements.id in (?)', Achievement.limited_time_ids)
  end

  scope :include_related, -> { includes(:item, :title) }
  scope :with_filters, -> (filters, character = nil) do
    if filters[:limited] == 'hide'
      exclude_time_limited
    end
  end

  scope :ordered, -> do
    joins(category: :type)
      .includes(:item, :title, category: :type)
      .order('achievements.patch DESC, achievement_types.order, achievement_categories.order, ' \
             'achievements.order DESC, achievements.id DESC')
  end

  def self.limited_time_ids
    ((310..312).to_a +   # Starting township quests
     (1757..1773).to_a + # GARO
     (2110..2114).to_a + # Feast Championships
     (1540..1547).to_a + (1565..1572).to_a + (2007..2012).to_a + # The Feast
     [2487, 2488, 2712, 2713, 2785, 2786] + # Ishgardian Reconstruction
     [1419, 1420, 1421, 1422, 1423, 1424, 1425, 1426, 1427, 1428, 1429, 1430, 1431, 1432,
      1734, 1735, 1736, 1737, 1743, 1744, 1745, 1746]).freeze # Diadem
  end

  private
  def touch_title
    title&.update_column(:updated_at, Time.now)
  end
end

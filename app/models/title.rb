# == Schema Information
#
# Table name: titles
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  female_name_en :string(255)      not null
#  female_name_de :string(255)      not null
#  female_name_fr :string(255)      not null
#  female_name_ja :string(255)      not null
#  order          :integer          not null
#  achievement_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Title < ApplicationRecord
  translates :name, :female_name
  belongs_to :achievement, touch: true

  scope :include_related, -> { includes(achievement: { category: :type }) }
  scope :ordered, -> { joins(:achievement).order('achievements.patch desc', order: :desc) }
end

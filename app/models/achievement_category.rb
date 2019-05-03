# == Schema Information
#
# Table name: achievement_categories
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  type_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AchievementCategory < ApplicationRecord
  belongs_to :type, class_name: 'AchievementType'
  translates :name
end

# == Schema Information
#
# Table name: relics
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_de        :string(255)      not null
#  name_ja        :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order          :integer
#  type_id        :integer
#  achievement_id :integer
#
class Relic < ApplicationRecord
  has_many "character_#{name.pluralize}".to_sym
  has_many :characters, through: "character_#{name.pluralize}".to_sym
  belongs_to :type, class_name: 'RelicType'
  belongs_to :achievement, required: false
  translates :name

  # Stub for common collectable scope
  scope :include_sources, -> { all }

  def self.categories
    %w(weapons armor tools).freeze
  end
end

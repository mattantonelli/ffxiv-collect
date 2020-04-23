# == Schema Information
#
# Table name: items
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_de    :string(255)      not null
#  name_ja    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Item < ApplicationRecord
  has_many "character_#{name.pluralize}".to_sym
  has_many :characters, through: "character_#{name.pluralize}".to_sym
  translates :name

  def self.lucis_tool_ids
    ([2327, 2354, 2379, 2404, 2429, 2455, 2480, 2506, 2532, 2558, 2584] + # Base
     (8436..8446).to_a + # Supra
     (10132..10142).to_a).freeze # Lucis
  end

  def self.skysteel_tool_ids
    (29612..29644).to_a.freeze # Skysteel -> Dragonsung
  end

  def self.relic_tool_ids
    (Item.lucis_tool_ids + Item.skysteel_tool_ids).freeze
  end
end

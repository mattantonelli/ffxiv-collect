# == Schema Information
#
# Table name: instances
#
#  id           :bigint(8)        not null, primary key
#  name_en      :string(255)      not null
#  name_de      :string(255)      not null
#  name_fr      :string(255)      not null
#  name_ja      :string(255)      not null
#  content_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Instance < ApplicationRecord
  translates :name

  def self.valid_types
    ['Dungeon', 'Trial', 'Raid', 'Treasure Hunt'].freeze
  end
end

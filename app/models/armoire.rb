# == Schema Information
#
# Table name: armoires
#
#  id          :bigint(8)        not null, primary key
#  name_en     :string(255)      not null
#  name_de     :string(255)      not null
#  name_fr     :string(255)      not null
#  name_ja     :string(255)      not null
#  order       :integer          not null
#  patch       :string(255)
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  gender      :string(255)
#

class Armoire < ApplicationRecord
  include Collectable
  translates :name
  belongs_to :category, class_name: 'ArmoireCategory'
end

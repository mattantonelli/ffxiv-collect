# == Schema Information
#
# Table name: armoire_categories
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  order      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArmoireCategory < ApplicationRecord
  translates :name
  has_many :armoires, foreign_key: 'category_id'
end

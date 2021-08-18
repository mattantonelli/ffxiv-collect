# == Schema Information
#
# Table name: items
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  description_en :string(1000)     not null
#  description_de :string(1000)     not null
#  description_fr :string(1000)     not null
#  description_ja :string(1000)     not null
#  icon_id        :string(6)
#  tradeable      :boolean
#  unlock_type    :string(255)
#  unlock_id      :integer
#  crafter        :string(255)
#  recipe_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  price          :integer
#  plural_en      :string(255)
#  plural_de      :string(255)
#  plural_fr      :string(255)
#  plural_ja      :string(255)
#  quest_id       :integer
#
class Item < ApplicationRecord
  translates :name, :description, :plural
  belongs_to :unlock, polymorphic: true, required: false
  belongs_to :quest, required: false
end

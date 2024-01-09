# == Schema Information
#
# Table name: rules
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
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Rule < ApplicationRecord
  has_many :decks
  has_and_belongs_to_many :npcs

  translates :name, :description
end

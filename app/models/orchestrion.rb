# == Schema Information
#
# Table name: orchestrions
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
#  order          :integer
#  patch          :string(255)
#  category_id    :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#

class Orchestrion < ApplicationRecord
  belongs_to :category, class_name: 'OrchestrionCategory'
  has_many :character_orchestrions
  has_many :characters, through: :character_orchestrions
  translates :name, :description
  has_paper_trail on: [:update, :destroy]
end

# == Schema Information
#
# Table name: fashions
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
#  order          :integer          not null
#  patch          :string(255)
#  item_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Fashion < ApplicationRecord
  include Collectable
  translates :name, :description
end

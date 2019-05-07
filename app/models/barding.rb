# == Schema Information
#
# Table name: bardings
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  patch      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Barding < ApplicationRecord
  translates :name
end

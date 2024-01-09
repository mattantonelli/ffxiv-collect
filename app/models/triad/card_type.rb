# == Schema Information
#
# Table name: card_types
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#

class CardType < ApplicationRecord
  has_many :cards

  translates :name
end

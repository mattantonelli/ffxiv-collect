# == Schema Information
#
# Table name: emote_categories
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmoteCategory < ApplicationRecord
  translates :name
  has_many :emotes, foreign_key: 'category_id'
end

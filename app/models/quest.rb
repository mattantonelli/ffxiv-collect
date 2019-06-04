# == Schema Information
#
# Table name: quests
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)
#  name_de    :string(255)
#  name_fr    :string(255)
#  name_ja    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Quest < ApplicationRecord
  translates :name
end

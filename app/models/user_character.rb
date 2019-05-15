# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer
#  character_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserCharacter < ApplicationRecord
  belongs_to :user
  belongs_to :character
end

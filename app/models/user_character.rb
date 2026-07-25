# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  user_id      :integer
#

class UserCharacter < ApplicationRecord
  belongs_to :user
  belongs_to :character
end

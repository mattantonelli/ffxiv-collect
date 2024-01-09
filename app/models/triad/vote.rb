# == Schema Information
#
# Table name: votes
#
#  id         :bigint(8)        not null, primary key
#  deck_id    :integer
#  user_id    :integer
#  score      :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Vote < ApplicationRecord
  belongs_to :deck, counter_cache: :rating
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :deck_id
  validates_presence_of :user_id, :deck_id
end

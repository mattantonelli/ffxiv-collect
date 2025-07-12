# == Schema Information
#
# Table name: packs
#
#  id         :bigint(8)        not null, primary key
#  cost       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  item_id    :integer
#

class Pack < ApplicationRecord
  has_many :pack_cards
  has_many :cards, -> { numeric_ordered }, through: :pack_cards, dependent: :delete_all

  scope :include_related, -> { includes(cards: :type) }
  scope :ordered, -> { order(:id) }

  after_save :touch_related

  translates :name

  private
  def touch_related
    cards.touch_all
  end
end

# == Schema Information
#
# Table name: cards
#
#  id               :bigint(8)        not null, primary key
#  patch            :string(255)
#  card_type_id     :integer          not null
#  stars            :integer          not null
#  top              :integer          not null
#  right            :integer          not null
#  bottom           :integer          not null
#  left             :integer          not null
#  buy_price        :integer
#  sell_price       :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order            :integer
#  name_en          :string(255)      not null
#  name_de          :string(255)      not null
#  name_fr          :string(255)      not null
#  name_ja          :string(255)      not null
#  description_en   :text(65535)      not null
#  description_de   :text(65535)      not null
#  description_fr   :text(65535)      not null
#  description_ja   :text(65535)      not null
#  order_group      :integer
#  deck_order       :integer
#  formatted_number :string(255)      not null
#

class Card < ApplicationRecord
  include Collectable

  translates :name, :description

  belongs_to :type, class_name: 'CardType', foreign_key: :card_type_id
  has_many :npc_cards
  has_many :npcs, through: :npc_cards
  has_many :npc_rewards
  has_many :npc_sources, through: :npc_rewards, source: :npc
  has_many :sources, as: :collectable, dependent: :delete_all
  has_many :deck_cards
  has_many :decks, through: :deck_cards
  has_many :pack_cards
  has_many :packs, through: :pack_cards
  has_one :achievement, required: false

  after_save :touch_related

  scope :include_related, -> { include_sources.includes(:type) }
  scope :ordered, -> { order(patch: :desc, order_group: :desc, order: :desc) }
  scope :numeric_ordered, -> { order(:order) }
  scope :standard, -> { where(order_group: 0) }
  scope :ex, -> { where.not(order_group: 0) }

  def ex?
    order_group != 0
  end

  def formatted_number
    ex? ? "Ex. #{order}" : "No. #{order}"
  end

  def stat(side)
    value = self[side]
    value == 10 ? 'A' : value
  end

  def stats
    "#{top} #{right} #{bottom} #{left}".gsub(/10/, 'A')
  end

  def total_stats
    top + right + bottom + left
  end

  def self.no(number)
    Card.find_by(formatted_number: "No. #{number}")
  end

  def self.ex(number)
    Card.find_by(formatted_number: "Ex. #{number}")
  end

  def self.available_filters
    %i(owned unknown)
  end

  private
  def touch_related
    npcs.touch_all
    npc_sources.touch_all
    decks.touch_all
    packs.touch_all
  end
end

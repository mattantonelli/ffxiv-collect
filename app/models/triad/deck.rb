# == Schema Information
#
# Table name: decks
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  rule_id    :integer
#  npc_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rating     :integer
#  notes      :string(1000)
#  updated    :boolean          default(TRUE)
#  user_uid   :string(255)
#

class Deck < ApplicationRecord
  before_create :set_order
  after_create :add_vote

  belongs_to :user, primary_key: :uid, foreign_key: :user_uid
  belongs_to :rule, required: false
  belongs_to :npc, required: false
  has_many :deck_cards, dependent: :delete_all
  has_many :cards, through: :deck_cards
  has_many :votes, dependent: :delete_all

  scope :include_related, -> { includes(:user, :rule, :npc, cards: :type) }
  scope :ordered, -> { order(:id) }

  validates_with DeckValidator
  validates :rule, presence: true, unless: -> { rule_id.blank? }
  validates :npc,  presence: true, unless: -> { npc_id.blank? }

  def upvote(user)
    votes.find_or_create_by(user: user)
  end

  def downvote(user)
    votes.find_by(user: user)&.destroy
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(rule_id npc_id rating notes updated)
  end

  def self.ransackable_associations(auth_object = nil)
    super + %w(rule npc)
  end

  private
  def set_order
    deck_cards.each_with_index do |card, i|
      card.position = i + 1
    end
  end

  def add_vote
    votes.create!(user_id: user.id)
  end
end

class DeckValidator < ActiveModel::Validator
  def validate(deck)
    if deck.cards.size != 5
      deck.errors.add(:cards, :invalid_size)
    end

    stars = deck.cards.map(&:stars).freeze

    # Cards of ★★★★★ rarity: 1 card per deck
    if stars.count { |star| star == 5 } > 1
      deck.errors.add(:cards, :too_many_fives)
    end

    # Cards of ★★★★ rarity or more: 2 cards per deck
    if stars.count { |star| star >= 4 } > 2
      deck.errors.add(:cards, :too_many_rares)
    end

    if deck.npc_id.present? && deck.rule_id.present?
      deck.errors.add(:base, :multiple_purposes)
    end
  end
end

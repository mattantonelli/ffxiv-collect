module Triad::DecksHelper
  def purpose(deck)
    if deck.npc_id.present?
      link_to(deck.npc.name, npc_path(deck.npc))
    elsif deck.rule_id.present?
      deck.rule.name
    else
      t('triad.decks.general_use')
    end
  end

  def missing_cards(deck, owned_cards)
    (deck.cards.pluck(:id) - owned_cards).size
  end

  def usable?(deck, owned_cards)
    missing = missing_cards(deck, owned_cards)

    if missing == 0
      fa_icon('check', data: { toggle: 'tooltip', title: t('triad.decks.have_all_cards') })
    else
      card_count = t('triad.decks.card_count', count: missing)
      fa_icon('times', data: { toggle: 'tooltip',
                               title: t('triad.decks.missing_cards', card_count: card_count) })
    end
  end

  def deck_patch(deck)
    if deck.updated?
      content_tag(:span, t('triad.decks.after_5_5'), class: 'badge badge-primary')
    else
      content_tag(:span, t('triad.decks.before_5_5'), class: 'badge badge-secondary')
    end
  end

  def voted?(deck)
    Vote.exists?(deck: deck, user: current_user)
  end

  def card_position(card, user_card_ids)
    if index = user_card_ids.index(card.id)
      page = (index / 30) + 1
      row = (index % 30 / 5) + 1
      column = (index % 30 % 5) + 1

      t('triad.decks.card_position', page: page, row: row, column: column)
    else
      t('triad.decks.card_missing')
    end
  end
end

module Triad::CardsHelper
  def card_image(card)
    if card.ex?
      image_tag('cards/item_ex.png')
    else
      image_tag("cards/item#{card.stars}.png")
    end
  end

  def type_image(card)
    if card.card_type_id > 0
      image_tag('blank.png', class: 'card-type',
                style: "background-position: -#{20 * (card.card_type_id - 1)}px 0",
                data: { toggle: 'tooltip', placement: 'top', title: card.type.name })
    end
  end

  def card_number_badge(card)
    content_tag(:span, card.formatted_number, class: 'badge badge-secondary')
  end

  def stars(card)
    (fa_icon('star') * card.stars).html_safe
  end

  def rarity_options
    (1..5).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def select_tooltip_delay
    '{"show": 500, "hide": 0 }'
  end

  def format_description(card)
    card.description.gsub("\n", '<br>')
      .gsub(/\*(.*?)\*/, '<i>\1</i>')
      .html_safe
  end

  def format_price(price)
    if price > 0
      "#{number_with_delimiter(price)} MGP"
    else
      'N/A'
    end
  end
end

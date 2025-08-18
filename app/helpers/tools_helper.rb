module ToolsHelper
  def generic_collectable_value(collectable)
    @values&.dig(collectable.class.to_s.underscore.pluralize.to_sym, collectable.id) || 0
  end

  # Skips redundant tradeability checks
  def market_board_collectable_classes(collectable)
    "collectable tradeable#{' owned' if generic_collectable_owned?(collectable)}"
  end
end

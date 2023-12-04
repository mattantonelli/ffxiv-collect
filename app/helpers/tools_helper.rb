module ToolsHelper
  def generic_collectable_value(collectable)
    @values&.dig(collectable.class.to_s.underscore.pluralize.to_sym, collectable.id) || 0
  end
end

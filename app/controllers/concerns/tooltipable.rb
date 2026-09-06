module Tooltipable
  extend ActiveSupport::Concern

  included do
    # Skip irrelevant application controller hooks
    skip_before_action :set_locale, :set_characters, :display_announcements, on: :tooltip
  end

  def tooltip
    collection = controller_name.classify.constantize
    id_field = "#{controller_name.singularize}_id"

    @collectable = collection.include_sources.find(params[id_field])

    render 'shared/tooltip', layout: false
  end
end

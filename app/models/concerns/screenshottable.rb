module Screenshottable
  extend ActiveSupport::Concern

  included do
    has_many_attached :screenshots
  end
end

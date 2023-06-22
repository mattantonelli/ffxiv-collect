class SharedController < ApplicationController
  skip_before_action :set_locale, :set_characters, :display_announcements

  def filter
  end
end

class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_character

  SUPPORTED_LOCALES = %w(en de fr ja).freeze

  def new_session_path(scope)
    new_user_session_path
  end

  private
  def set_locale
    locale = cookies['locale']

    unless locale.present?
      locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first&.downcase

      unless locale.present? && SUPPORTED_LOCALES.include?(locale)
        locale = I18n.default_locale
      end

      cookies['locale'] = locale
    end

    I18n.locale = cookies['locale']
  end

  def set_character
    if user_signed_in?
    else
      # @character = Character.find(7660136)
    end
  end
end

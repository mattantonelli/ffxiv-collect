class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_current_character

  SUPPORTED_LOCALES = %w(en de fr ja).freeze

  def new_session_path(scope)
    new_user_session_path
  end

  def redirect_to_previous
    redirect_to session.delete(:return_to) || root_path
  end

  def verify_signed_in!
    unless user_signed_in?
      flash[:alert] = 'You must be signed in to do that.'
      redirect_to_previous
    end
  end

  def display_verify_alert!
    if user_signed_in? && !@character&.verified_user?
      flash.now[:alert_fixed] = 'This character is unverified. If you wish to track manual collections for this ' \
        "character, please #{view_context.link_to 'verify your ownership', character_verify_path(@character)}."
    end
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

  def set_current_character
    if user_signed_in?
      @character = current_user.character
    else
      id = cookies['character']
      @character = Character.find_by(id: id) if id.present?
    end
  end
end

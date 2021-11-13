class LocaleController < ApplicationController
  def update
    locale = params[:locale]&.downcase
    locale = I18n.default_locale unless %w(en de fr ja).include?(locale)
    set_permanent_cookie(:locale, locale.downcase)
    redirect_to request.referer
  end
end

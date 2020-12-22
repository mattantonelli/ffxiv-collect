class StaticController < ApplicationController
  def home
  end

  def commands
    @oauth_url = 'https://discord.com/oauth2/authorize' \
      "?client_id=#{Rails.application.credentials.dig(:discord, :interactions_client_id)}" \
      '&scope=applications.commands'
  end

  def not_found
    flash[:error] = t('alerts.not_found')
    redirect_to root_path
  end
end

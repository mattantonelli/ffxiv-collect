class StaticController < ApplicationController
  def home
  end

  def commands
    @oauth_url = 'https://discord.com/oauth2/authorize' \
      "?client_id=#{Rails.application.credentials.dig(:discord, :interactions_client_id)}" \
      '&scope=applications.commands'
  end

  def faq
    @users = Redis.current.get('stats-users')
    @characters = Redis.current.get('stats-characters')
    @active_characters = Redis.current.get('stats-active-characters')
    @achievement_characters = Redis.current.get('stats-achievement-characters')
  end

  def not_found
    flash[:error] = t('alerts.not_found')
    redirect_to root_path
  end
end

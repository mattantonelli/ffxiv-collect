class StaticController < ApplicationController
  def home
  end

  def commands
    @oauth_url = 'https://discord.com/oauth2/authorize' \
      "?client_id=#{Rails.application.credentials.dig(:discord, :interactions_client_id)}" \
      '&scope=applications.commands'
  end

  def faq
    @users = User.count
    @characters = Character.visible.count
    @active_characters = Character.visible.recent.count
    @achievement_characters = Character.visible.recent.with_public_achievements.count
  end

  def not_found
    flash[:error] = t('alerts.not_found')
    redirect_to root_path
  end
end

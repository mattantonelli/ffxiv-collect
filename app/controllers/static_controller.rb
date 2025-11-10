class StaticController < ApplicationController
  def commands
    @oauth_url = 'https://discord.com/oauth2/authorize' \
      "?client_id=#{Rails.application.credentials.dig(:discord, :interactions_client_id)}" \
      '&scope=applications.commands'
  end

  def credits
    @developers = Character.where(id: [7660136]).order(:name)
    @sourcers = Character.where(id: [17928665, 4763007]).order(:name)
    @translators = Character.where(id: [17928665, 7547066, 8011032, 7944237, 5602002, 30220792, 3937654]).order(:name)
    @supporters = Character.where(supporter: true).order(:name)
  end

  def faq
    @users = Redis.current.get('stats-users')
    @characters = Redis.current.get('stats-characters')
    @achievement_characters = Redis.current.get('stats-achievement-characters')
  end

  def home
    @discord_link = view_context.link_to('Discord', 'https://discord.gg/bA9fYQjEYy', target: '_blank')
  end

  def blank
    render locals: { hide_footer: true }
  end

  def not_found
    flash[:error] = t('alerts.not_found')
    redirect_to root_path
  end
end

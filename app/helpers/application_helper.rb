module ApplicationHelper
  def flash_class(level)
    case level
    when /notice/  then 'alert-info'
    when /success/ then 'alert-success'
    when /error/   then 'alert-danger'
    when /alert/   then 'alert-warning'
    end
  end

  def active_link?(path, path_controller = nil)
    if path_controller.present?
      controller_name.include?(path_controller)
    else
      current_page?(path)
    end
  end

  def nav_link(text, path, path_controller = nil)
    active = active_link?(path, path_controller)
    link_to text, path, class: "nav-link#{' active' if active}"
  end

  def format_date(date)
    date.in_time_zone('America/New_York').strftime('%e %b %Y %H:%M')
  end

  def format_date_short(date)
    date&.utc&.strftime('%b %-d, %Y')
  end

  def avatar(user)
    image_tag(user.avatar_url, class: 'avatar')
  end

  def username(user)
    "#{user.username}##{user.discriminator.to_s.rjust(4, '0')}"
  end

  def format_text(text)
    text.gsub("\n\n", ' ')
      .gsub('   -', "<br>&nbsp;&nbsp;&nbsp;-")
      .gsub(/\*\*(.*?)\*\*/, '<b>\1</b>')
      .gsub(/\*(.*?)\*/, '<i>\1</i>')
      .html_safe
  end

  def format_text_long(text)
    format_text(text.gsub(/\n+/, '<br>'))
  end

  def truncate_text(text, length)
    data = { toggle: 'tooltip', title: text } if text.size > length
    content_tag(:span, text.truncate(length), data: data)
  end

  def fa_check(condition, text = true)
    condition ? fa_icon('check', text: ('Yes' if text)) : fa_icon('times', text: ('No' if text))
  end

  def region
    case(I18n.locale)
    when :fr then 'fr'
    when :de then 'de'
    when :ja then 'jp'
    else 'na'
    end
  end

  def ga_tid
    Rails.application.credentials.dig(:google_analytics, :tracking_id)
  end

  def teamcraft_url(type, id)
    "https://ffxivteamcraft.com/db/#{I18n.locale}/#{type}/#{id}"
  end

  def mogboard_url(item_id)
    "https://mogboard.com/market/#{item_id}"
  end
end

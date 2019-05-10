module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'  then 'alert-info'
    when 'success' then 'alert-success'
    when 'error'   then 'alert-danger'
    when 'alert'   then 'alert-warning'
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
    date.strftime('%b %Y')
  end

  def avatar(user)
    image_tag(user.avatar_url, class: 'avatar')
  end

  def format_text(text)
    text.gsub("\n\n", ' ')
      .gsub('   -', "<br>&nbsp;&nbsp;&nbsp;-")
      .gsub(/\*\*(.*?)\*\*/, '<b>\1</b>')
      .gsub(/\*(.*?)\*/, '<i>\1</i>')
      .html_safe
  end

  def truncate_text(text, length)
    data = { toggle: 'tooltip', title: text } if text.size > length
    content_tag(:span, text.truncate(length), data: data)
  end

  def character_selected?
    current_user&.character_id&.present?
  end

  def owned(ids, id)
    if ids.include?(id)
      fa_icon('check-square')
    else
      fa_icon('square')
    end
  end

  def ga_tid
    Rails.application.credentials.dig(:google_analytics, :tracking_id)
  end
end

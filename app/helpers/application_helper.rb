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
    @character.present?
  end

  def td_owned(ids, collectable, manual = true)
    owned = ids.include?(collectable.id)
    if manual && @character.verified_user?(current_user)
      content_tag(:td, class: 'text-center', data: { value: owned ? 1 : 0 }) do
        check_box_tag(nil, nil, owned, class: 'own',
                      data: { path: polymorphic_path(collectable, action: owned ? :remove : :add) })
      end
    else
      if owned
        content_tag(:td, fa_icon('check'), class: 'text-center', data: { value: 1 })
      else
        content_tag(:td, fa_icon('times'), class: 'text-center', data: { value: 0 })
      end
    end
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
end

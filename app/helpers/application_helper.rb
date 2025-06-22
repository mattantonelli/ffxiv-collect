module ApplicationHelper
  def flash_class(level)
    case level
    when /notice/  then 'alert-dark'
    when /success/ then 'alert-success'
    when /error/   then 'alert-danger'
    when /alert/   then 'alert-warning'
    end
  end

  def active_path?(path)
    path.match?("/#{controller_name}")
  end

  def nav_link(text, icon, path, fab: false, action: nil)
    icon = fab ? fab_icon(icon, text: text) : fa_icon(icon, text: text)

    if action.present?
      bold = action_name == action
    else
      bold = active_path?(path)
    end

    link_to icon, path, class: "nav-link#{' bold' if bold}"
  end

  def safe_image_tag(src, options = {})
    begin
      image_tag(src, options)
    rescue Sprockets::Rails::Helper::AssetNotFound
    end
  end

  def format_date(date)
    date.in_time_zone('America/New_York').strftime('%e %b %Y %H:%M')
  end

  def format_date_short(date)
    date&.utc&.strftime('%b %-d, %Y')
  end

  def avatar(user)
    image_tag(user.avatar_url, class: 'avatar') if user.avatar_url.present?
  end

  def username(user)
    fab_icon('discord', text: user.username) if user.present?
  end

  def fa_check(condition, text = true)
    condition ? fa_icon('check', text: ('Yes' if text)) : fa_icon('times', text: ('No' if text))
  end

  def gender_symbol(gender)
    return nil unless gender.present?
    fa_icon(gender == 'male' ? 'mars' : 'venus', data: { toggle: 'tooltip', title: t("only.#{gender}") })
  end

  def stars(value)
    (fa_icon('star') * value).html_safe
  end

  def region
    case(I18n.locale)
    when :fr then 'fr'
    when :de then 'de'
    when :ja then 'jp'
    else 'na'
    end
  end

  def new_feature_badge(small: false)
    content_tag(:span, small ? '!' : t('new'), class: "badge badge-success#{ ' badge-pill' if small}")
  end

  def teamcraft_url(type, id)
    "https://ffxivteamcraft.com/db/#{I18n.locale}/#{type}/#{id}"
  end

  def garland_tools_url(type, id)
    "https://www.garlandtools.org/db/##{type}/#{id}"
  end

  def universalis_url(item_id)
    "https://universalis.app/market/#{item_id}"
  end
end

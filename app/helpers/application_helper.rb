module ApplicationHelper
  def flash_class(level)
    case level
    when /notice/  then 'alert-dark'
    when /success/ then 'alert-success'
    when /error/   then 'alert-danger'
    when /alert/   then 'alert-warning'
    end
  end

  def active_link?(path, path_controller = nil)
    if path_controller.present?
      controller_path == path_controller
    else
      current_page?(path)
    end
  end

  def nav_link(text, path, path_controller = nil)
    active = active_link?(path, path_controller)
    link_to text, path, class: "nav-link#{' active' if active}"
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
    image_tag(user.avatar_url, class: 'avatar')
  end

  def username(user)
    "#{user.username}##{user.discriminator.to_s.rjust(4, '0')}" if user.present?
  end

  def format_text(text)
    text.gsub('   -', "<br>&nbsp;&nbsp;&nbsp;-")
      .gsub(/\*\*(.*?)\*\*/, '<b>\1</b>')
      .gsub(/\*(.*?)\*/, '<i>\1</i>')
      .html_safe
  end

  def format_text_long(text)
    format_text(text.gsub(/\u203B/, "<br>\u203B"))
  end

  def format_tooltip(tooltip)
    tooltip
      .gsub(/(?<=\n)(.*?):/, '<b>\1:</b>')
      .gsub("\n", '<br>')
      .html_safe
  end

  def truncate_text(text, length)
    data = { toggle: 'tooltip', title: text } if text.size > length
    content_tag(:span, text.truncate(length), data: data)
  end

  def fa_check(condition, text = true)
    condition ? fa_icon('check', text: ('Yes' if text)) : fa_icon('times', text: ('No' if text))
  end

  def generic_sprite(collection, collectable)
    case collection
    when /(mounts|minions|fashions)/
      sprite(collectable, "#{collection}-small")
    when 'spells'
      content_tag :div, class: 'spell-sprite' do
        sprite(collectable, :spell)
      end
    when 'hairstyles'
      hairstyle_sample_image(collectable)
    when 'orchestrions'
      image_tag('orchestrion.png')
    else
      sprite(collectable, collection.singularize)
    end
  end

  def gender_symbol(gender)
    return nil unless gender.present?
    fa_icon(gender == 'male' ? 'mars' : 'venus', data: { toggle: 'tooltip', title: "#{gender.capitalize} Only" })
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

  def garland_tools_url(type, id)
    "https://www.garlandtools.org/db/##{type}/#{id}"
  end

  def universalis_url(item_id)
    "https://universalis.app/market/#{item_id}"
  end
end

module MountsHelper
  def custom_music(mount)
    if mount.custom_music?
      content_tag(:span, fa_icon('music'), title: I18n.t('mounts.custom_music'), data: { toggle: 'tooltip', html: true })
    end
  end

  def seat_count(mount, right: true)
    fa_icon('couch', text: mount.seats, right: right, title: I18n.t('mounts.seats_tooltip', number: mount.seats),
            data: { toggle: 'tooltip' })
  end
end

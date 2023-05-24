module MountsHelper
  def custom_music_link(mount)
    if mount.bgm_sample.present?
      link_to(fa_icon('music'), mount_path(mount), title: I18n.t('mounts.custom_music'),
              data: { toggle: 'tooltip', html: true } )
    end
  end

  def seat_count(mount, right: true)
    fa_icon('couch', text: mount.seats, right: right, title: I18n.t('mounts.seats_tooltip', number: mount.seats),
            data: { toggle: 'tooltip' })
  end
end

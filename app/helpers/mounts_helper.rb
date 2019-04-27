module MountsHelper
  def mount_icon(mount)
    image_tag('blank.png', class: 'mount-icon', style: "background-position: -#{40 * (mount.id - 1)}px 0")
  end

  def mount_large(mount)
    image_tag('blank.png', class: 'mount-large', style: "background-position: -#{192 * (mount.id - 1)}px 0")
  end

  def mount_footprint(mount)
    image_tag('blank.png', class: 'mount-footprint', style: "background-position: -#{128 * (mount.id - 1)}px 0")
  end

  def flying(mount)
    if mount.flying
      fa_icon('check', text: 'Yes')
    else
      fa_icon('times', text: 'No')
    end
  end
end

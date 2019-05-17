module MountsHelper
  def flying(mount)
    if mount.flying
      fa_icon('check', text: 'Yes')
    else
      fa_icon('times', text: 'No')
    end
  end
end

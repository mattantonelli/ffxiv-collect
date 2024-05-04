require 'csv'

module XIVData
  extend self

  BASE_URL = Rails.root.join('vendor/xiv-data').freeze
  IMAGE_PATH = '/var/rails/images/ffxiv'.freeze
  MUSIC_PATH = '/var/rails/music/ffxiv'.freeze

  def sheet(sheet, locale: nil, raw: false, drop_zero: true)
    if raw
      url = "#{BASE_URL}/rawexd/#{sheet}.csv"
    elsif locale.present?
      url = "#{BASE_URL}/exd-all/#{sheet}.#{locale}.csv"
    else
      url = "#{BASE_URL}/exd-all/#{sheet}.csv"
    end

    data = URI.open(url).readlines
    headers = data[1].chomp
    CSV.new(data.drop(drop_zero ? 4 : 3).join, headers: headers.split(','))
  end

  def icon_path(icon_id, hd: false)
    number = icon_id.to_s.rjust(6, '0')
    directory = number.first(3).ljust(6, '0')
    "ui/icon/#{directory}/#{number}#{'_hr1' if hd}.tex"
  end

  def card_image_path(id)
    number = id.to_s.rjust(6, '0')
    directory = number.first(3).ljust(6, '0')
    "#{IMAGE_PATH}/ui/icon/#{directory}/#{number}.png"
  end

  def image_path(icon)
    "#{IMAGE_PATH}/#{icon.sub('tex', 'png')}"
  end

  def music_filename(path)
    "#{path.sub(/.*\//, '').sub('.scd', '.ogg')}"
  end

  def music_path(path)
    "#{MUSIC_PATH}/#{music_filename(path)}"
  end

  def related_id(value)
    value.sub(/.*#(\d+)/, '\1')
  end
end

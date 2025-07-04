require 'csv'
require 'open-uri'

module XIVData
  extend self

  BASE_PATH = Rails.root.join('vendor/xiv-data/exd').freeze
  IMAGE_PATH = '/var/rails/images/ffxiv'.freeze
  MUSIC_PATH = '/var/rails/music/ffxiv'.freeze

  def sheet(sheet, locale: nil)
    if locale.present?
      path = "#{BASE_PATH}/#{sheet}.#{locale}.csv"
    else
      path = "#{BASE_PATH}/#{sheet}.en.csv"
    end

    data = File.read(path)
    CSV.parse(data, headers: true)
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

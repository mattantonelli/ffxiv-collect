require 'csv'
require 'open-uri'

module XIVData
  extend self

  BASE_PATH = Rails.root.join('vendor/xiv-data/exd').freeze
  IMAGE_PATH = '/var/rails/images/ffxiv'.freeze

  def sheet(sheet, locale: nil)
    if locale.present?
      path = "#{BASE_PATH}/#{sheet}.#{locale}.csv"
    else
      path = "#{BASE_PATH}/#{sheet}.en.csv"
    end

    data = File.read(path)
    CSV.parse(data, headers: true)
  end

  def format_icon_id(icon_id)
    icon_id.to_s.rjust(6, '0')
  end

  def image_path(icon_id, hd: false)
    number = format_icon_id(icon_id)
    directory = number.first(3).ljust(6, '0')
    icon_path = "ui/icon/#{directory}/#{number}#{'_hr1' if hd}.png"

    "#{IMAGE_PATH}/#{icon_path}"
  end
end

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

  def image_path(icon_id)
    number = format_icon_id(icon_id)
    directory = number.first(3).ljust(6, '0')
    "ui/icon/#{directory}/#{number}.tex"
  end

  def download_image(path, format: 'png', hd: false)
    url = "https://v2.xivapi.com/api/asset"
    params = { path: path, format: format }
    params[:path].sub!('.tex', '_hr1.tex') if hd

    RestClient::Request.execute(
      method: :get,
      url: url,
      headers: { params: params },
      raw_response: true
    )
  end
end

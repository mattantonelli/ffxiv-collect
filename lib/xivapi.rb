module XIVAPI
  extend self

  include Sanitizers

  BASE_URL = 'https://v2.xivapi.com/api'.freeze
  USER_AGENT = "FFXIVCollect".freeze
  LANGUAGES = %w(en de fr ja).freeze
  LIMIT = 500.freeze

  def sheet(name, fields: [], transient: [], limit: XIVAPI::LIMIT)
    XIVAPI::Sheet.new(
      name,
      limit: limit,
      fields: decorate_fields(fields),
      transient: decorate_fields(transient)
    )
  end

  def asset(path, format: 'png', hd: false)
    url = "#{BASE_URL}/asset"
    params = { path: path, format: format }
    params[:path].sub!('.tex', '_hr1.tex') if hd

    RestClient::Request.execute(
      method: :get,
      url: url,
      headers: { params: params, user_agent: USER_AGENT },
      raw_response: true
    )
  end

  def asset_path(asset_id, type: 'icon')
    number = asset_id.to_s.rjust(6, '0')
    directory = number.first(3).ljust(6, '0')
    "ui/#{type}/#{directory}/#{number}.tex"
  end

  def translate(row, field, key, type: :name, preserve_space: false)
    LANGUAGES.each_with_object({}) do |lang, h|
      value = row["#{field}@lang(#{lang})"]

      value = case type
              when :name
                sanitize_name(value)
              when :text
                sanitize_text(value, preserve_space)
              when :skill
                sanitize_skill_description(value)
              end

      h["#{key}_#{lang}".to_sym] = value
    end
  end

  private
  def decorate_fields(fields)
    fields.flat_map do |field|
      case field
      when /@i18n/
        # Add language decorators for all supported languages
        name = field.split('@').first

        LANGUAGES.map do |lang|
          "#{name}@lang(#{lang})"
        end
      else
        field
      end
    end
  end
end

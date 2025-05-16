module XIVAPI
  extend self

  BASE_URL = 'https://v2.xivapi.com/api/sheet'.freeze
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

  def translate(row, field, key)
    LANGUAGES.each_with_object({}) do |lang, h|
      h["#{key}_#{lang}".to_sym] = row["#{field}@lang(#{lang})"]
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

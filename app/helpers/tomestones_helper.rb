module TomestonesHelper
  def tomestone_name(tomestone, locale = :en)
    name = tomestone["name_#{locale}"]

    case locale
    when :en
      name.sub(/.+ Of (.+)/, '\1')
    when :de
      name.sub(/.+ Der (.+)/, '\1')
    when :fr
      name.sub(/.+Allagois (.+) Inhabituel(.*)/, '\1\2')
    when :ja
      name.sub(/.+:(.+)/, '\1')
    end
  end
end

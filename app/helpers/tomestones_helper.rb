module TomestonesHelper
  def tomestone_name(tomestone, locale = :en)
    name = tomestone["name_#{locale}"]

    case locale
    when :fr
      name.split(' ')[-2]
    when :ja
      name.split(':').last
    else
      name.split(' ').last
    end
  end
end

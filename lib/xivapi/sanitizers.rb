module XIVAPI::Sanitizers
  # Titleize names and translate various tags
  def sanitize_name(name)
    name = name.split(' ').each { |s| s[0] = s[0].upcase }.join(' ')
    name.gsub('[t]', 'der')
      .gsub('[a]', 'e')
      .gsub('[A]', 'er')
      .gsub('[p]', '')
      .gsub(/\uE0BE ?/, '')
      .gsub('<SoftHyphen/>', "\u00AD")
      .gsub('<Indent/>', ' ')
      .gsub(/\<.*?\>/, '')
      .gsub(/\((.)/) { |match| match.upcase } # (extreme) → (Extreme)
  end

  # Replace various tags with the appropriate text
  def sanitize_text(text, preserve_space)
    text = text.gsub('<SoftHyphen/>', "\u00AD")
      .gsub(/<Switch.*?><Case\(1\)>(.*?)<\/Case>.*?<\/Switch>/m, '\1')
      .gsub(/<If.*?>(.*?)<Else\/>.*?<\/If>/m, '\1')
      .gsub(/<\/?Emphasis>/, '*')
      .gsub(/<UIForeground>.*?<\/UIGlow>(.*?)<UIGlow>.*?<\/UIForeground>/, '**\1**')
      .gsub(/<Highlight>(.*?)<\/Highlight>/, '**\1**')
      .gsub(/<Split\((.*?),.*?>/, '\1')
      .gsub('<Indent/>', ' ')
      .gsub('ObjectParameter(1)', 'Player')
      .gsub(/<.*?>(.*?)<\/.*?>/, '')

    unless preserve_space
      text = text.gsub("\r", "\n").gsub("\n", ' ')
    end

    text.strip
  end

  # Clean up tags
  def sanitize_skill_description(text)
    text.gsub('<SoftHyphen/>', "\u00AD")
      .gsub(/<UIForeground>.*?<\/UIGlow>(.*?)<UIGlow>.*?<\/UIForeground>/, '**\1**')
      .gsub('<Indent/>', ' ')
      .gsub(/<.*?>(.*?)<\/.*?>/, '')
      .strip
  end
end

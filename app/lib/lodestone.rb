module Lodestone
  ROOT_URL = 'https://na.finalfantasyxiv.com/lodestone'.freeze
  DESKTOP_USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) ' \
    'Chrome/104.0.0.0 Safari/537.36'
  MOBILE_USER_AGENT = 'Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) ' \
    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36'.freeze

  extend self

  def fetch_character(character_id)
    character = fetch_profile(character_id)
    character[:mounts] = fetch_mounts(character_id)
    character[:minions] = fetch_minions(character_id)

    # Do not fetch achievements if they are set to private
    character[:achievements] = character[:achievements_count] == -1 ? [] : fetch_achievements(character_id)

    character
  end

  def free_company_members(free_company_id, page: 1)
    url = "#{ROOT_URL}/freecompany/#{free_company_id}/member?page=#{page}"

    begin
      doc = Nokogiri::HTML.parse(RestClient.get(url, user_agent: DESKTOP_USER_AGENT))
      members = doc.css('.entry__bg').map { |entry| element_id(entry) }

      # If there are additional pages, recursively continue fetching members
      if doc.at_css('.btn__pager__next:not(.btn__pager__no)').present?
        members += free_company_members(free_company_id, page: page + 1)
      end

      members
    rescue RestClient::ExceptionWithResponse, StandardError
      []
    end
  end

  def search(name, server)
    doc = character_document(params: { q: name.strip.gsub(/[‘’]/, "'"), worldname: server })
    doc.css('.entry__chara__link').map do |character|
      {
        id: element_id(character),
        name: character.at_css('.entry__name').text,
        avatar: character.at_css('.entry__chara__face > img').attributes['src'].value,
        server: server
      }
    end
  end

  def verified?(character_id, code)
    doc = character_document(character_id: character_id)
    doc.css('.character__character_profile').text.include?(code)
  end

  private
  def fetch_profile(character_id)
    doc = character_document(character_id: character_id)
    doc = Nokogiri::HTML.parse(RestClient.get("#{ROOT_URL}/character/#{character_id}", user_agent: MOBILE_USER_AGENT))

    character = {
      id: character_id,
      name: doc.at_css('.frame__chara__name').text,
      server: doc.at_css('.frame__chara__world').text[/^\w+/],
      data_center: doc.at_css('.frame__chara__world').text.gsub(/.*\[(\w+)\]/, '\1'),
      gender: doc.at_css('.character-block__profile').text.match?('♂') ? 'male' : 'female',
      portrait: doc.at_css('.character__detail__image > a > img').attributes['src'].value,
      avatar: doc.at_css('.frame__chara__face > img').attributes['src'].value,
      last_parsed: Time.now
    }

    # If the character's achievements are private, the link will be missing from the nav
    character[:achievements_count] = -1 unless doc.css('.ldst-nav').text.match?('Achievements')

    # If the character has a free company, create/update it and add it to the profile
    free_company = doc.at_css('.entry__freecompany')

    if free_company.present? && !free_company.attributes['href'].value.match?('pvp')
      free_company_id = element_id(free_company)
      name = doc.at_css('.character__freecompany__name > h4').text
      character[:free_company_id] = free_company_id

      if free_company = FreeCompany.find_by(id: free_company_id)
        free_company.update!(name: name)
      else
        FreeCompany.create!(id: free_company_id, name: name)
      end
    else
      character[:free_company_id] = nil
    end

    character
  end

  def fetch_mounts(character_id)
    doc = character_document(endpoint: 'mount', character_id: character_id)
    return [] unless doc.present?
    Mount.where(name_en: doc.css('.mount__name').map(&:text)).pluck(:id)
  end

  def fetch_minions(character_id)
    doc = character_document(endpoint: 'minion', character_id: character_id)
    return [] unless doc.present?
    Minion.summonable.where(name_en: doc.css('.minion__name').map(&:text)).pluck(:id)
  end

  def fetch_achievements(character_id)
    # If the character exists, grab their recent achievements from the overview page
    # and return those achievements, unless they fill the whole page
    if character = Character.find_by(id: character_id)
      doc = character_document(endpoint: 'achievement', character_id: character_id)

      recent = doc.css('.entry__achievement').map { |achievement| parse_achievement(achievement) }
      owned = character.achievement_ids
      new_achievements = recent.reject { |achievement| owned.include?(achievement[:id]) }
      return new_achievements if new_achievements.size < recent.size
    end

    # Otherwise, grab the achievements from each page
    AchievementType.pluck(:id).flat_map do |type|
      doc = character_document(endpoint: "achievement/kind/#{type}", character_id: character_id)
      next [] unless doc.present?
      doc.css('.entry__achievement--complete').map { |achievement| parse_achievement(achievement) }
    end
  end

  def parse_achievement(achievement)
    { id: element_id(achievement), date: element_time(achievement) }
  end

  def character_document(endpoint: nil, character_id: nil, params: {})
    url = [ROOT_URL, 'character', character_id, endpoint].compact.join('/')

    begin
      Nokogiri::HTML.parse(RestClient.get(url, user_agent: MOBILE_USER_AGENT, params: params))
    rescue RestClient::NotFound
      # Ignore 404s on missing collections
    end
  end

  def element_id(element)
    element.attributes['href'].value.match(/(\d+)\/$/)[1].to_i
  end

  def element_time(element)
    time = element.at_css('.entry__activity__time').text.match(/ldst_strftime\((\d+)/)[1]
    Time.at(time.to_i).to_formatted_s(:db)
  end
end

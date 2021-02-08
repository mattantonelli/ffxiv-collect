require 'thwait'

module Lodestone
  ROOT_URL = 'https://na.finalfantasyxiv.com/lodestone/character'.freeze
  MOBILE_USER_AGENT = 'Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) ' \
    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36'.freeze

  extend self

  def fetch(id)
    character = {}
    threads = []

    threads << Thread.new { character.merge!(fetch_character(id)) }
    threads << Thread.new { character[:mounts] = fetch_mounts(id) }
    threads << Thread.new { character[:minions] = fetch_mounts(id) }
    threads << Thread.new { character[:achievements] = fetch_achievements(id) }

    ThreadsWait.all_waits(*threads)
    character
  end

  def search(name, server)
    # TODO
  end

  private
  def fetch_character(id)
    doc = document(id)
    doc = Nokogiri::HTML.parse(RestClient.get("#{ROOT_URL}/#{id}", user_agent: MOBILE_USER_AGENT))

    character = {
      id: id,
      name: doc.at_css('.frame__chara__name').text,
      server: doc.at_css('.frame__chara__world').text[/^\w+/],
      gender: doc.at_css('.character-block__profile').text.match?('♂') ? 'male' : 'female',
      portait: doc.at_css('.character__detail__image > a > img').attributes['src'].value,
      avatar: doc.at_css('.frame__chara__face > img').attributes['src'].value,
      last_parsed: Time.now
    }

    # If the character has a free company, create/update it and add it to the profile
    if free_company = doc.at_css('.entry__freecompany')
      free_company_id = free_company.attributes['href'].value[/\d+/]
      name = doc.at_css('.character__freecompany__name > h4').text
      character[:free_company_id] = free_company_id

      if free_company = FreeCompany.find_by(id: free_company_id)
        free_company.update!(name: name)
      else
        FreeCompany.create!(id: free_company_id, name: name)
      end
    end

    character
  end

  def fetch_mounts(id)
    doc = document(id, 'mount')
    Mount.where(name_en: doc.css('.mount__name').map(&:text)).pluck(:id)
  end

  def fetch_minions(id)
    doc = document(id, 'minion')
    Minion.where(name_en: doc.css('.minion__name').map(&:text)).pluck(:id)
  end

  def fetch_achievements(id)
    # If the character exists, grab their recent achievements from the overview page
    # and return those achievements, unless they fill the whole page
    if character = Character.find_by(id: id)
      doc = document(id, 'achievement')
      recent = doc.css('.entry__achievement').map { |achievement| parse_achievement(achievement) }
      owned = character.achievement_ids
      new_achievements = recent.reject { |achievement| owned.include?(achievement[:id]) }
      return new_achievements if new_achievements.size < recent.size
    end

    # Otherwise, grab the achievements from each page
    achievements = []
    threads = AchievementType.pluck(:id).map do |type|
      Thread.new do
        doc = document(id, "achievement/kind/#{type}")
        break unless doc.present?
        achievements += doc.css('.entry__achievement--complete').map { |achievement| parse_achievement(achievement) }
      end
    end

    ThreadsWait.all_waits(*threads)
    achievements
  end

  def parse_achievement(achievement)
    {
      id: achievement.attributes['href'].value.match(/(\d+)\/$/)[1].to_i,
      date: Time.at(achievement.at_css('.entry__activity__time').text.match(/ldst_strftime\((\d+)/)[1].to_i)
    }
  end

  def document(id, endpoint = nil)
    url = [ROOT_URL, id, endpoint].compact.join('/')
    begin
      Nokogiri::HTML.parse(RestClient.get(url, user_agent: MOBILE_USER_AGENT))
    rescue RestClient::NotFound
      # Ignore 404s on Legacy achievements
      raise unless url.match?('/achievement/kind/13')
    end
  end
end

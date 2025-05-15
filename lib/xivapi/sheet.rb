module XIVAPI
  BASE_URL = 'https://v2.xivapi.com/api/sheet'.freeze
  USER_AGENT = "FFXIVCollect".freeze
  LIMIT = 500.freeze

  class Sheet
    include Enumerable

    def initialize(name)
      @url = "#{BASE_URL}/#{name}"
      @params = { limit: LIMIT }
    end

    def each
      while true
        response = RestClient.get(@url, { params: @params, user_agent: USER_AGENT })
        rows = JSON.parse(response)['rows']

        rows.each do |row|
          yield row['fields']
        end

        break if rows.size < LIMIT

        @params[:after] = @params[:after].to_i + LIMIT
      end
    end
  end
end

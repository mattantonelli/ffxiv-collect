module XIVAPI
  class Sheet
    include Enumerable

    def initialize(name, limit:, fields: [], transient: [])
      @url = "#{BASE_URL}/sheet/#{name}"
      @limit = [limit, XIVAPI::LIMIT].min
      @total = 0

      @params = { limit: @limit }
      @params[:fields] = fields.join(',') unless fields.empty?
      @params[:transient] = transient.join(',') unless transient.empty?
    end

    def each
      while true
        response = RestClient.get(@url, { params: @params, user_agent: USER_AGENT })
        rows = JSON.parse(response)['rows']

        rows.each do |row|
          result = row['fields'].merge({ '#' => row['row_id'] })
          result.merge!(row['transient']) if row.has_key?('transient')
          yield result
        end

        @total += rows.size
        break if @total >= @limit || rows.size < @limit

        @params[:after] = @params[:after].to_i + @limit
      end
    end
  end
end

UNIVERSALIS_BASE_URL = 'https://universalis.app/api/v2'.freeze

namespace :prices do
  desc 'Sets the latest known market board prices for items by data center'
  task cache: :environment do
    item_ids = Item.where(tradeable: true).where.not(unlock_id: nil).pluck(:id)

    Character.data_centers.each do |dc|
      puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S %Z')}] Updating prices for #{dc}"
      key = "prices-#{dc.downcase}"

      item_ids.each_slice(100) do |ids|
        begin
          url = "#{UNIVERSALIS_BASE_URL}/#{dc}/#{ids.join(',')}?listings=1&entries=0"
          response = JSON.parse(RestClient::Request.execute(url: url, method: :get, verify_ssl: false))

          prices = response['items'].map do |id, item|
            last_updated = Time.at(item['lastUploadTime'] / 1000).to_date
            price, world = item['listings'].first&.values_at('pricePerUnit', 'worldName')

            [id, { price: price || 'N/A', world: world || 'N/A', last_updated: last_updated }.to_json]
          end

          Redis.current.hmset(key, prices.flatten)
        rescue RestClient::ExceptionWithResponse => e
          puts "There was a problem fetching #{url}"
          puts e.response
        rescue
          puts "There was an unexpected problem fetching #{url}"
        end
      end
    end
  end
end

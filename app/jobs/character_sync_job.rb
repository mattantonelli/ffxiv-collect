class CharacterSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      Character.fetch(args[0])
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::NotFound
      Sidekiq.logger.info('Character is no longer available.')
    end
  end
end

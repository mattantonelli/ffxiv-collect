class CharacterSyncJob < ApplicationJob
  queue_as :character
  unique :until_executed, on_conflict: :log

  def perform(*args)
    begin
      Character.fetch(args[0])
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::NotFound
      Sidekiq.logger.info("Character #{args[0]} is no longer available.")
    end
  end
end

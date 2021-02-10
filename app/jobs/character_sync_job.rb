class CharacterSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      Character.fetch(args[0])
    rescue RestClient::NotFound
      Sidekiq::Logging.logger.info('Character is no longer available.')
    end
  end
end

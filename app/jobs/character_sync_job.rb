class CharacterSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      Character.fetch(args[0])
    rescue XIVAPI::Errors::RequestError => e
      if e.message == 'Lodestone is currently down for maintenance.'
        Sidekiq::Logging.logger.info(e.message)
      else
        raise
      end
    end
  end
end

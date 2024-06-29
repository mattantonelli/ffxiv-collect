class CharacterSyncJob < ApplicationJob
  queue_as :character
  unique :until_and_while_executing, on_conflict: :log

  def perform(*args)
    id = args[0]
    attempts = 0

    begin
      Character.fetch(id)
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::NotFound
      Sidekiq.logger.info("Character #{id} is no longer available.")
    rescue RestClient::TooManyRequests
      if attempts < 3
        Sidekiq.logger.info("Rate limited while fetching character #{id}. Retrying...")
        attempts += 1
        sleep(3)
        retry
      else
        Sidekiq.logger.error("Rate limited while fetching character #{id}")
      end
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("There was a problem fetching character #{id}")
      Rails.logger.error(e.response)
    rescue Lodestone::PrivateProfileError
      # Cannot fetch characters with private profiles
    rescue StandardError
      Rails.logger.error("There was a problem fetching character #{id}")
      raise
    end
  end
end

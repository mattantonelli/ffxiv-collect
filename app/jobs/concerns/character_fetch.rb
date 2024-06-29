module CharacterFetch
  extend ActiveSupport::Concern

  def fetch_character(id)
    Sidekiq.logger.info("Looking up character #{id}.")
    character = Character.find_by(id: id)

    if character.nil? || character.syncable?
      Sidekiq.logger.info('Fetching...')
      attempts = 0

      begin
        Character.fetch(id)
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
      rescue Lodestone::PrivateProfileError
        # Cannot fetch characters with private profiles
      end
    else
      Sidekiq.logger.info('Character is up to date.')
    end
  end
end

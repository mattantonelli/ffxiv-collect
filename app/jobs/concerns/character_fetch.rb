module CharacterFetch
  extend ActiveSupport::Concern

  def fetch_character(id)
    character = Character.find_by(id: id)

    # Only fetch new or stale characters
    if character.nil? || character.stale?
      Sidekiq.logger.info("Fetching #{id}")
      begin
        CharacterSyncJob.new.perform(id)
      rescue StandardError
        # Logged in child job - continue execution
      end
    end
  end
end

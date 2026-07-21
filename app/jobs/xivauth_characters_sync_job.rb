class XivauthCharactersSyncJob < ApplicationJob
  include CharacterFetch
  queue_as :character
  unique :until_and_while_executing, on_conflict: :log

  def perform(*args)
    begin
      Sidekiq.logger.info('Syncing characters returned by XIVAuth.')

      user = User.find(args[0])
      character_ids = args[1]

      character_ids.each do |id|
        Sidekiq.logger.info("Fetching character #{id}")
        character = Character.find_by(id: id)

        # Fetch character from the Lodestone if needed
        unless character.present?
          begin
            character = CharacterSyncJob.perform_now(id)
          rescue StandardError
            # Logged in child job - continue execution
          end
        end

        # For extra security, only verify characters that have not already been claimed
        unless character.verified_user_id.present?
          character.update!(verified_user_id: user.id)
        end

        # Add the character to the user's list of characters
        begin
          user.characters << character
        rescue ActiveRecord::RecordNotUnique
          # Character is already on the list
        end

        # Set their currently selected character if it is not already set
        unless user.character_id.present?
          user.update!(character_id: id)
        end
      end
    rescue StandardError
      Sidekiq.logger.error("There was a problem syncing XIVAuth characters for user #{user.id}")
      raise
    end
  end
end

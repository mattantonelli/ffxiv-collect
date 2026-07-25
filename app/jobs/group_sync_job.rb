class GroupSyncJob < SidekiqJob
  include CharacterFetch

  sidekiq_options(
    queue: :free_company
  )

  def perform(*args)
    begin
      Sidekiq.logger.info('Refreshing group members.')
      group = Group.friendly.find(args[0])

      group.character_ids.each do |id|
        begin
          fetch_character(id)
        rescue StandardError
          # Error has already been logged. Continue fetching the remaining characters.
        end
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::ExceptionWithResponse => e
      Sidekiq.logger.error("There was a problem fetching group #{group.id}")
      Sidekiq.logger.error(e.response)
    rescue StandardError
      Sidekiq.logger.error("There was a problem fetching group #{group.id}")
      raise
    ensure
      group.update!(syncing: false)
    end
  end
end

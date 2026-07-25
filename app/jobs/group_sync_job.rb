class GroupSyncJob < SidekiqJob
  include CharacterFetch

  sidekiq_options(
    queue: :free_company
  )

  def perform(*args)
    begin
      Sidekiq.logger.info('Refreshing group members.')

      group_id = args[0]

      Group.friendly.find(group_id).character_ids.each do |id|
        fetch_character(id)
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::ExceptionWithResponse => e
      Sidekiq.logger.error("There was a problem fetching group #{group_id}")
      Sidekiq.logger.error(e.response)
    rescue StandardError
      Sidekiq.logger.error("There was a problem fetching group #{group_id}")
      raise
    end
  end
end

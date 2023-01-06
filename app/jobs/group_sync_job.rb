class GroupSyncJob < ApplicationJob
  include CharacterFetch
  queue_as :free_company
  unique :until_executed, on_conflict: :raise

  def perform(*args)
    begin
      Sidekiq.logger.info('Refreshing group members.')

      Group.friendly.find(args[0]).character_ids.each do |id|
        fetch_character(id)
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    end
  end
end

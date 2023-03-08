class GroupSyncJob < ApplicationJob
  include CharacterFetch
  queue_as :free_company
  unique :until_and_while_executing, on_conflict: :log

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
      Rails.logger.error("There was a problem fetching group #{group_id}")
      Rails.logger.error(e.response)
    rescue StandardError
      Rails.logger.error("There was a problem fetching group #{group_id}")
      raise
    end
  end
end

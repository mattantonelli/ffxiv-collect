class GroupSyncJob < ApplicationJob
  include CharacterFetch
  queue_as :free_company
  # unique :until_and_while_executing, on_conflict: :log

  def perform(*args)
    begin
      Sidekiq.logger.info('Refreshing group members.')

      group_id = args[0]

      Group.friendly.find(group_id).character_ids.each do |id|
        begin
          CharacterSyncJob.perform_now(id)
        rescue StandardError
          # Logged in child job - continue execution
        end
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

class FreeCompanySyncJob < ApplicationJob
  include CharacterFetch
  queue_as :free_company
  unique :until_executed, on_conflict: :raise

  def perform(*args)
    begin
      Sidekiq.logger.info('Looking up free company.')
      free_company = FreeCompany.fetch(args[0])
      member_ids = Lodestone.free_company_members(free_company.id)

      # Purge members who are no longer part of the free company
      Sidekiq.logger.info('Purging old members.')
      free_company.members.where.not(id: member_ids).update_all(free_company_id: nil)

      # Fetch each member of the free company
      member_ids.each do |id|
        fetch_character(id)
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    end
  end
end

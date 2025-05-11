class FreeCompanySyncJob < ApplicationJob
  include CharacterFetch
  queue_as :free_company
  unique :until_and_while_executing, on_conflict: :log

  def perform(*args)
    begin
      Sidekiq.logger.info('Looking up free company.')

      free_company_id = args[0]
      free_company = FreeCompany.fetch(free_company_id)
      member_ids = Lodestone.free_company_members(free_company_id)

      # Purge members who are no longer part of the free company
      Sidekiq.logger.info('Purging old members.')
      free_company.members.where.not(id: member_ids).update_all(free_company_id: nil)

      # Fetch each member of the free company
      member_ids.each do |id|
        begin
          fetch_character(id)
        rescue Lodestone::PrivateProfileError
          Sidekiq.logger.info("Skipping private profile #{id}")
        end
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::NotFound
      Sidekiq.logger.info("Free company #{free_company_id} is no longer available.")
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("There was a problem fetching free company #{free_company_id}")
      Rails.logger.error(e.response)
    rescue StandardError
      Rails.logger.error("There was a problem fetching free company #{free_company_id}")
      raise
    end
  end
end

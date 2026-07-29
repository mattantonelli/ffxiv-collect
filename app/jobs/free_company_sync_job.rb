class FreeCompanySyncJob < SidekiqJob
  include CharacterFetch

  sidekiq_options(
    queue: :free_company
  )

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
        begin
          fetch_character(id)
        rescue StandardError
          # Error has already been logged. Continue fetching the remaining characters.
        end
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    rescue RestClient::NotFound
      Sidekiq.logger.info("Free company #{free_company.id} is no longer available.")
    rescue RestClient::ExceptionWithResponse => e
      Sidekiq.logger.error("There was a problem fetching free company #{free_company.id}")
      Sidekiq.logger.error(e.response)
    rescue StandardError
      Sidekiq.logger.error("There was a problem fetching free company #{free_company.id}")
      raise
    ensure
      free_company&.update!(syncing: false)
    end
  end
end

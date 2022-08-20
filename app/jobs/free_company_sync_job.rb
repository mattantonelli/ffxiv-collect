class FreeCompanySyncJob < ApplicationJob
  queue_as :free_company
  unique :until_executed, on_conflict: :log

  def perform(*args)
    begin
      free_company = FreeCompany.find(args[0])
      member_ids = Lodestone.free_company_members(free_company.id)

      # Purge members who are no longer part of the free company
      puts "Purging old members."
      free_company.members.where.not(id: member_ids).update_all(free_company_id: nil)

      # Fetch each member of the free company
      member_ids.each do |id|
        puts "Looking up character #{id}."
        character = Character.find_by(id: id)

        if character.nil? || character.syncable?
          puts "Fetching..."
          begin
            Character.fetch(id)
          rescue RestClient::NotFound
            Sidekiq.logger.info("Character #{id} is no longer available.")
          rescue RestClient::TooManyRequests
            Sidekiq.logger.error("Rate limited while fetching character #{id}")
          end
        else
          puts "Character is up to date."
        end
      end
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Sidekiq.logger.info('Lodestone is down for maintenance.')
    end
  end
end

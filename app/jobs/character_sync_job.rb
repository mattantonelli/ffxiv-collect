class CharacterSyncJob < SidekiqJob
  include CharacterFetch

  sidekiq_options(
    queue: :character
  )

  def perform(*args)
    fetch_character(args[0])
  end
end

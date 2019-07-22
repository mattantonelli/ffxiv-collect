class CharacterSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Character.fetch(args[0])
  end
end

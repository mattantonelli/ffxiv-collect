module Queueable
  extend ActiveSupport::Concern

  included do
    def in_queue?
      queue = self.class.to_s.underscore

      return true if Sidekiq::Queue.new(queue).any? { |job| job.item['args'][0]['arguments'][0] == id }

      Sidekiq::Workers.new.any? do |_, _, worker|
        worker['queue'] == queue && worker['payload']['args'][0]['arguments'][0] == id
      end
    end
  end
end

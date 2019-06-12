module Collectable
  extend ActiveSupport::Concern

  included do
    scope :hide_premium, -> (hide) do
      if hide
        left_joins(:sources).where('sources.type_id <> ? or sources.type_id is null', SourceType.find_by(name: 'Premium'))
      end
    end

    scope :with_user_options, -> (options) { hide_premium(options[:premium] == 'hide') }

    has_many :sources, as: :collectable
    accepts_nested_attributes_for :sources
    has_paper_trail
  end
end

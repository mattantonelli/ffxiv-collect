module Collectable
  extend ActiveSupport::Concern

  included do
    scope :hide_premium, -> (hide) do
      if hide
        where('sources.type_id <> ? or sources.type_id is null', SourceType.find_by(name: 'Premium'))
      end
    end

    scope :hide_limited, -> (hide) do
      if hide
        where('sources.type_id not in (?) or sources.type_id is null',
              SourceType.where(name: %w(Event Feast Limited)).pluck(:id))
      end
    end

    scope :with_filters, -> (filters) do
      left_joins(:sources)
        .hide_premium(filters[:premium] == 'hide')
        .hide_limited(filters[:limited] == 'hide')
        .distinct
    end

    has_many :sources, as: :collectable
    accepts_nested_attributes_for :sources
    has_paper_trail on: [:update, :destroy]
  end
end

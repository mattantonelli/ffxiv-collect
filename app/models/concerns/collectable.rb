module Collectable
  extend ActiveSupport::Concern

  included do
    scope :hide_premium, -> (hide) do
      where('sources.premium = FALSE or sources.type_id IS NULL') if hide
    end

    scope :hide_limited, -> (hide) do
      where('sources.limited = FALSE or sources.type_id IS NULL') if hide
    end

    scope :hide_unknown, -> (hide) do
      where('sources.id IS NOT NULL') if hide
    end

    scope :filter_gender, -> (option, character) do
      if option.present? && model.column_names.include?('gender')
        if option == 'character'
          # Show collectables usable by the character's gender
          where('gender is null or gender = ?', character.gender) if character.present?
        elsif option != 'all'
          # Hide collectables for the given gender
          where('gender is null or gender <> ?', option)
        end
      end
    end

    scope :with_filters, -> (filters, character = nil) do
      left_joins(:sources)
        .hide_premium(filters[:premium] == 'hide')
        .hide_limited(filters[:limited] == 'hide')
        .hide_unknown(filters[:unknown] == 'hide')
        .filter_gender(filters[:gender], character)
        .distinct
    end

    scope :include_sources, -> { includes(sources: [:type, :related] )}

    has_many "character_#{name.pluralize}".to_sym
    has_many :characters, through: "character_#{name.pluralize}".to_sym
    has_many :sources, as: :collectable, dependent: :delete_all
    accepts_nested_attributes_for :sources
    has_paper_trail
  end
end

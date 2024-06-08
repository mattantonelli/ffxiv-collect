module Collectable
  extend ActiveSupport::Concern

  included do
    scope :tradeable, -> { where.not(item_id: nil) }

    scope :hide_premium, -> (hide) do
      where('sources.premium = FALSE or sources.id IS NULL') if hide && available_filters.include?(:premium)
    end

    scope :hide_limited, -> (hide) do
      where('sources.limited = FALSE or sources.id IS NULL') if hide && available_filters.include?(:limited)
    end

    scope :hide_ranked_pvp, -> (hide) do
      where('sources.text_en not like "%Season %" or sources.id IS NULL') if hide && available_filters.include?(:ranked_pvp)
    end

    scope :hide_unknown, -> (hide) do
      where('sources.id IS NOT NULL') if hide && available_filters.include?(:unknown)
    end

    scope :filter_gender, -> (option, character) do
      if option.present? && available_filters.include?(:gender)
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
        .hide_ranked_pvp(filters[:ranked_pvp] == 'hide')
        .hide_unknown(filters[:unknown] == 'hide')
        .filter_gender(filters[:gender], character)
        .distinct
    end

    scope :ranked, -> do
      joins(:sources)
        .where('sources.limited = FALSE AND sources.premium = FALSE')
        .distinct
    end

    scope :include_sources, -> { includes(sources: [:type, :related] )}

    has_many "character_#{name.pluralize.underscore}".to_sym
    has_many :characters, through: "character_#{name.pluralize.underscore}".to_sym
    has_many :sources, as: :collectable, dependent: :delete_all
    accepts_nested_attributes_for :sources
    has_paper_trail

    def expansion
      patch[0]
    end

    def tradeable?
      self[:item_id].present?
    end
  end

  class_methods do
    def materiel_container(number)
      case number
      when 3
        tradeable.where('patch < 4.0')
      when 4
        tradeable.where('patch >= 4.0 AND patch < 5.0')
      else
        none
      end
    end
  end
end

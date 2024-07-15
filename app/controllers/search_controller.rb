class SearchController < ApplicationController
  include PrivateCollection
  before_action -> { check_privacy!(:mounts, :minions, :facewear) }
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    @types = [
      { model: Mount, label: I18n.t('mounts.title'), value: 'Mount' },
      { model: Minion, label: I18n.t('minions.title'), value: 'Minion' },
      { model: Orchestrion, label: I18n.t('orchestrions.title'), value: 'Orchestrion' },
      { model: Hairstyle, label: I18n.t('hairstyles.title'), value: 'Hairstyle' },
      { model: Emote, label: I18n.t('emotes.title'), value: 'Emote' },
      { model: Barding, label: I18n.t('bardings.title'), value: 'Barding' },
      { model: Armoire, label: I18n.t('armoires.title'), value: 'Armoire' },
      { model: Fashion, label: I18n.t('fashions.title'), value: 'Fashion' },
      { model: Facewear, label: I18n.t('facewear.title'), value: 'Facewear' },
      { model: Frame, label: I18n.t('frames.title'), value: 'Frame' },
      { model: Card, label: I18n.t('cards.title'), value: 'Card' },
    ]

    @hidden_types = cookies[:hidden_types]&.split(',')&.map(&:constantize) || []
    @models = @types.pluck(:model)
    @source_types = SourceType.all.with_filters(cookies).ordered
    @patches = searchable_patches
    @search = ransack_with_patch_search

    @collectables = @models.flat_map do |model|
      # The search form needs a query, so we will eventually set it to the last search
      @q = model.include_sources.with_filters(cookies).ransack(@search)

      collectables = @q.result.ordered
      collectables = collectables.summonable if model == Minion # Exclude variant minions
      collectables
    end

    if @character.present?
      @owned_ids = @models.each_with_object({}) do |model, h|
        h[model.to_s.underscore.pluralize.to_sym] = @character.send("#{model.to_s.underscore}_ids")
      end
    end
  end
end

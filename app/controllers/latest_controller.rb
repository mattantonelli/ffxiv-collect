class LatestController < ApplicationController
  include Collection
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    models = [Achievement, Mount, Minion, Orchestrion, Hairstyle, Emote, Barding, Fashion, Card, Frame, Armoire]

    @patches = searchable_patches
    @search = ransack_with_patch_search

    @collectables = models.flat_map do |model|
      # The search form needs a query, so we will eventually set it to the last search
      @q = model.include_sources.with_filters(cookies).ransack(@search)

      collectables = @q.result.ordered
      collectables = collectables.summonable if model == Minion # Exclude variant minions
      collectables
    end

    if @character.present?
      @owned_ids = models.each_with_object({}) do |model, h|
        h[model.to_s.underscore.pluralize.to_sym] = @character.send("#{model.to_s.underscore}_ids")
      end
    end
  end
end

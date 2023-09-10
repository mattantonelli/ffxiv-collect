class LatestController < ApplicationController
  include Collection
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    models = [Achievement, Mount, Minion, Orchestrion, Hairstyle, Emote, Barding, Fashion, Frame, Armoire]

    @search = params[:q] || {}
    @search[:patch_eq] ||= Achievement.all.maximum(:patch)

    @collectables = models.flat_map do |model|
      collectables = model.include_sources.with_filters(cookies).ransack(@search).result.ordered
      collectables = collectables.summonable if model == Minion # Exclude variant minions
      collectables
    end

    if @character.present?
      @owned_ids = models.each_with_object({}) do |model, h|
        h[model.to_s.underscore.pluralize.to_sym] = @character.send("#{model.to_s.underscore}_ids")
      end
    end

    @patches = Achievement.pluck(:patch).compact.uniq
  end
end

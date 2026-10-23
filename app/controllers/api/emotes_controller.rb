class Api::EmotesController < ApiController
  def index
    query = Emote.all.ransack(@query)
    @emotes = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @emote = Emote.include_sources.find(params[:id])
  end
end

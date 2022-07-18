class Api::EmotesController < ApiController
  def index
    query = Emote.all.ransack(@query)
    @emotes = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @emote = Emote.include_sources.find_by(id: params[:id])
    render_not_found unless @emote.present?
  end
end

class Api::EmotesController < ApiController
  def index
    query = Emote.all.ransack(@query)
    @emotes = query.result.includes(:category).include_sources
      .order(patch: :desc, id: :desc).distinct.limit(params[:limit])
    @owned = Redis.current.hgetall(:emotes)
  end

  def show
    @emote = Emote.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:emotes, params[:id]) }
    render_not_found unless @emote.present?
  end
end

class Api::EmotesController < ApiController
  def index
    query = Emote.all.ransack(@query)
    @emotes = query.result.includes(:category).include_sources
      .order(patch: :desc, order: :desc).distinct.limit(params[:limit])
  end

  def show
    @emote = Emote.find_by(id: params[:id])
    render_not_found unless @emote.present?
  end
end

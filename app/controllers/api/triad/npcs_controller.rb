class Api::Triad::NPCsController < ApiController
  before_action :set_options

  def index
    query = NPC.all.ransack(@query.except(:deck))
    @npcs = query.result.include_related.ordered.distinct.limit(params[:limit])
    @npcs = @npcs.includes(fixed_cards: :type, variable_cards: :type) if @include_deck
  end

  def show
    @npc = NPC.includes(fixed_cards: :type, variable_cards: :type, rewards: :type).find_by(id: params[:id])
    render_not_found unless @npc.present?
  end

  private
  def set_options
    @include_deck = params[:deck].present?
  end

  def set_owned
    @owned = Redis.current.hgetall('cards')
  end
end

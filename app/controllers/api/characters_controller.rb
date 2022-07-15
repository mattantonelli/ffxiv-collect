class Api::CharactersController < ApiController
  def show
    @character = Character.find_by(id: params[:id])

    if !@character.present?
      render json: { status: 404, error: 'Not found' }, status: :not_found
    elsif !@character.public?
      render json: { status: 403, error: 'Character is set to private' }, status: :forbidden
    else
      @triad = @character.triple_triad
    end

    relic_ids = @character.relic_ids
    @relics = Relic.categories.each_with_object({}) do |category, h|
      ids = Relic.joins(:type).where('relic_types.category = ?', category).pluck(:id)
      owned_relic_ids = (ids & relic_ids)
      h[category] = { count: owned_relic_ids.size, total: ids.size }
      h[category][:ids] = owned_relic_ids if params[:ids].present?
    end

    if @character&.syncable?
      @character.sync
    end
  end
end

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

    if @character.present? && @character.stale? && !@character.in_queue?
      @character.sync
    end
  end
end

class Api::OwnedController < ApiController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_owned
  before_action :authenticate_api_token!

  # POST /api/characters/:character_id/:collection/owned
  def create
    unless @token
      return render json: { status: 401, error: 'Missing or invalid token' }, status: :unauthorized
    end

    if @token.character_id != params[:character_id].to_i
      return render json: { status: 403, error: 'Token does not match character' }, status: :forbidden
    end

    unless @token.character.verified_user?(@token.user)
      return render json: { status: 403, error: 'Character is no longer verified for this user' }, status: :forbidden
    end

    unless Api::OwnedWriter.writeable?(params[:collection])
      return render json: { status: 400, error: 'Collection is not writeable via API' }, status: :bad_request
    end

    ids = params[:ids]

    unless ids.is_a?(Array) && ids.any?
      return render json: { status: 400, error: 'ids must be a non-empty array of integers' }, status: :bad_request
    end

    result = Api::OwnedWriter.new(@token.character, params[:collection], ids).call
    @token.touch_usage!(request.user_agent)

    render json: {
      character_id:  @token.character_id,
      collection:    params[:collection],
      added:         result.added,
      already_owned: result.already_owned,
      invalid_ids:   result.invalid_ids,
      total_owned:   result.total_owned
    }
  end

  private

  def authenticate_api_token!
    header = request.headers['Authorization']
    raw    = header&.match(/\ABearer\s+(.+)\z/)&.captures&.first
    @token = CharacterApiToken.authenticate(raw)
  end
end

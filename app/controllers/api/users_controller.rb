class Api::UsersController < ApiController
  before_action :set_character_id

  def show
    redirect_to api_character_path(@character_id, request.query_parameters)
  end

  def owned
    redirect_to api_character_owned_path(@character_id, request.query_parameters)
  end

  def missing
    redirect_to api_character_missing_path(@character_id, params[:collection], request.query_parameters)
  end

  private
  def set_character_id
    user = User.find_by(uid: params[:id] || params[:user_id])

    if user.present?
      if user.character_id.present?
        @character_id = user.character_id
      else
        render json: { status: 404, error: 'User has no character selected' }, status: :not_found
      end
    else
      render json: { status: 404, error: "User not found. Sign in with Discord and select your character at #{root_url}" },
        status: :not_found
    end
  end
end

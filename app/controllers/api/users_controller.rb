class Api::UsersController < ApiController
  def show
    user = User.find_by(uid: params[:id])

    if user.present?
      character = user.character

      if !character.present?
        render json: { status: 404, error: 'User has no character selected' }, status: :not_found
      elsif !character.public?
        render json: { status: 403, error: "User's character is set to private" }, status: :forbidden
      else
        redirect_to api_character_path(character)
      end
    else
      render json: { status: 404, error: "User not found. Sign in with Discord and select your character at #{root_url}" },
        status: :not_found
    end
  end
end

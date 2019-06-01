class Api::UsersController < ApiController
  def show
    @user = User.find_by(uid: params[:id])

    if !@user.present?
      render json: { status: 404, error: 'Not found' }, status: :not_found
    else
      @characters = @user.verified_characters.visible || []

      if @characters.present?
        @triad = @user.triple_triad
      end
    end
  end
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def discord
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in(@user)

    if !@user.character.present? && cookies['character'].present?
      @user.update(character_id: cookies['character'])
      @user.characters << Character.find_by(id: cookies['character']) unless @user.characters.exists?(cookies['character'])
    end

    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end

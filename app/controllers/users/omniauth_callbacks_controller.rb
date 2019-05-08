class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def discord
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in(@user)
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end

class SettingsController < ApplicationController
  before_action :verify_signed_in!
  before_action :set_user

  def edit
    if @character.present? && !@character.verified_user?(@user)
      flash.now[:alert_fixed] = "If you wish to change the settings for this character, " \
        "please #{view_context.link_to 'verify your ownership', verify_character_path}."
    end
  end

  def update_user
    if current_user.update(user_params)
      flash[:success] = 'Your user settings have been updated.'
      redirect_to settings_path
    else
      flash[:error] = 'There was a problem updating your user settings.'
      render :edit
    end
  end

  def update_character
    if @character.present? && @character.verified_user?(current_user) && @character.update(character_params)
      flash[:success] = 'Your character settings have been updated.'
      redirect_to settings_path
    else
      flash[:error] = 'There was a problem updating your character settings.'
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:database)
  end

  def character_params
    params.require(:character).permit(:public)
  end

  def set_user
    @user = current_user
  end
end

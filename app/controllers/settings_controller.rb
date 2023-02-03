class SettingsController < ApplicationController
  before_action :verify_signed_in!
  before_action :set_user

  def edit
    if @character.present? && !@character.verified_user?(@user)
      link = view_context.link_to(t('alerts.verify_ownership'), verify_character_path(@character))
      flash.now[:alert_fixed] = t('alerts.settings_not_verified', link: link)
    end
  end

  def update_user
    if current_user.update(user_params)
      flash[:success] = t('alerts.settings_updated')
      redirect_to settings_path
    else
      flash[:error] = t('alerts.settings_error')
      render :edit
    end
  end

  def update_character
    if @character.present? && @character.verified_user?(current_user) && @character.update(character_params)
      flash[:success] = t('alerts.settings_updated')
      redirect_to settings_path
    else
      flash[:error] = t('alerts.settings_error')
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

class CharactersController < ApplicationController
  before_action :verify_signed_in!, only: [:verify, :validate]
  skip_before_action :set_current_character, only: [:refresh, :verify, :validate]
  before_action :set_character, only: [:refresh, :verify, :validate]
  before_action :set_code, only: [:verify, :validate]

  def search
    @server, @name = params.values_at(:server, :name)

    if @server.present? && @name.present?
      @characters = Character.search(@server, @name)
      if @characters.empty?
        flash.now[:alert] = 'No characters found.'
      end
    else
      session[:return_to] = request.referer
    end
  end

  def select
    begin
      character = Character.fetch(params[:character_id])

      if user_signed_in?
        current_user.update(character_id: params[:character_id])
      else
        cookies[:character] = params[:character_id]
      end

      if character.achievements_count == 0
        flash[:alert] = 'Achievements for this character are set to private. You can make your achievements public ' \
          "#{view_context.link_to('here', 'https://na.finalfantasyxiv.com/lodestone/my/setting/account/')}.".html_safe
      else
        flash[:success] = "Your character has been set."
      end

      redirect_to_previous
    rescue
      flash[:error] = 'There was a problem selecting that character.'
      render :search
    end
  end

  def refresh
    if @character.refresh
      flash[:success] = 'Your character has been refreshed.'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = 'Sorry, you can only request a manual refresh every 12 hours.'
      redirect_back(fallback_location: root_path)
    end
  end

  def verify
    session[:return_to] = request.referer
  end

  def validate
    if XIVAPI_CLIENT.character_verified?(id: @character.id, token: @character.verification_code(current_user))
      @character.update!(verified_user_id: current_user.id)
      flash[:success] = 'Your character has been verified. You can now remove the code from your profile.'
      redirect_to_previous
    else
      flash[:alert] = 'Your character could not be verified. Please check your profile and try again.'
      render :verify
    end
  end

  private
  def set_character
    @character = Character.find(params[:character_id])
  end

  def set_code
    @code = @character.verification_code(current_user)
  end
end

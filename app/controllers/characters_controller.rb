class CharactersController < ApplicationController
  before_action :verify_signed_in!, only: [:verify, :validate, :destroy]
  skip_before_action :set_current_character, only: [:refresh, :verify, :validate]
  before_action :set_character, only: [:refresh, :verify, :validate]
  before_action :set_code, only: [:verify, :validate]

  def search
    @server, @name = params.values_at(:server, :name)
    @search = @server.present? && @name.present?

    if @search
      begin
        @characters = Character.search(@server, @name)
        if @characters.empty?
          flash.now[:alert] = 'No characters found.'
        end
      rescue XIVAPI::Errors::RequestError
        flash.now[:alert] = 'There was a problem contacting the Lodestone. Please try again later.'
      end
    else
      if user_signed_in?
        @characters = current_user.characters.order(:server, :name).to_a
          .sort_by { |character| character.verified_user_id == current_user.id ? 0 : 1 }
      end
    end
  end

  def select
    begin
      character = Character.fetch(params[:character_id])

      if user_signed_in?
        current_user.characters << character unless current_user.characters.exists?(character.id)
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

      redirect_to root_path
    rescue
      flash[:error] = 'There was a problem selecting that character.'
      render :search
    end
  end

  def forget
    if user_signed_in?
      current_user.update(character_id: nil)
    else
      cookies[:character] = nil
    end

    flash[:success] = 'You are no longer tracking a character.'
    redirect_to root_path
  end

  def destroy
    current_user.characters.delete(params[:id])
    redirect_to search_characters_path
  end

  def refresh
    begin
      if @character.refresh
        flash[:success] = 'Your character has been refreshed.'
      else
        flash[:alert] = 'Sorry, you can only request a manual refresh once every 24 hours.'
      end
    rescue XIVAPI::Errors::RequestError
      flash[:alert] = 'There was a problem contacting the Lodestone. Please try again later.'
    end

    redirect_back(fallback_location: root_path)
  end

  def verify
    session[:return_to] = request.referer
  end

  def validate
    begin
      if XIVAPI_CLIENT.character_verified?(id: @character.id, token: @character.verification_code(current_user))
        @character.update!(verified_user_id: current_user.id)
        flash[:success] = 'Your character has been verified. You can now remove the code from your profile.'
        redirect_to_previous
      else
        flash[:alert] = 'Your character could not be verified. Please check your profile and try again.'
        render :verify
      end
    rescue XIVAPI::Errors::RequestError
      flash[:alert] = 'There was a problem contacting the Lodestone. Please try again later.'
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

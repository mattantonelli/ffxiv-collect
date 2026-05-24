class CharacterApiTokensController < ApplicationController
  before_action :verify_signed_in!
  before_action :set_character
  before_action :verify_owner!

  def show
    @api_token = @character.api_token
    @plaintext_token = flash[:plaintext_token]
  end

  def create
    @character.api_token&.destroy
    api_token = @character.create_api_token!(user: current_user)
    flash[:plaintext_token] = api_token.plaintext
    flash[:success] = 'A new API token has been generated. Copy it now — it will only be shown once.'
    redirect_to character_api_token_path(character_id: @character.id)
  end

  def destroy
    @character.api_token&.destroy
    flash[:success] = 'API token revoked.'
    redirect_to character_api_token_path(character_id: @character.id)
  end

  private

  def set_character
    @character = Character.find_by(id: params[:character_id])
    return if @character.present?

    flash[:error] = 'Character not found.'
    redirect_to root_path
  end

  def verify_owner!
    unless @character.verified_user?(current_user)
      flash[:error] = 'You must be the verified owner of this character to manage its API token.'
      redirect_to character_path(@character)
    end
  end
end

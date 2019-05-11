class CharactersController < ApplicationController
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
      character = Character.fetch(params[:id])
      current_user.update(character_id: params[:id])

      if character.achievements_count == 0
        flash[:alert] = 'Achievements for this character are set to private. You can make your achievements public ' \
          "#{view_context.link_to('here', 'https://na.finalfantasyxiv.com/lodestone/my/setting/account/')}.".html_safe
      else
        flash[:success] = "Your character has been set."
      end

      redirect_to session.delete(:return_to)
    rescue
      flash[:error] = 'There was a problem selecting that character.'
      render :search
    end
  end

  def refresh
    character = Character.find(params[:id])
    if character.refresh
      flash[:success] = 'Your character has been refreshed.'
      redirect_to request.referer
    else
      flash[:alert] = 'Sorry, you can only request a manual refresh every 12 hours.'
      redirect_to request.referer
    end
  end
end

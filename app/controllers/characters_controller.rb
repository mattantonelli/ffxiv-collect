class CharactersController < ApplicationController
  def search
    @server, @name = params.values_at(:server, :name)

    if @server.present? && @name.present?
      @characters = Character.search(@server, @name)
      if @characters.empty?
        flash.now[:alert] = 'No characters found.'
      end
    end
  end

  def select
    begin
      Character.fetch(params[:id]) unless Character.exists?(params[:id])
      current_user.update(character_id: params[:id])

      if Character.find(params[:id]).achievements_count == 0
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
end

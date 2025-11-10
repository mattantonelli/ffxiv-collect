class Admin::CharactersController < AdminController
  def index
    @q = Character.all.ransack(params[:q], auth_object: :admin)

    @verified, @public, @supporter = params.values_at(:verified, :public, :supporter)
    result = @q.result.includes(:verified_user).order(:created_at)
    result = result.where.not(verified_user_id: nil) if @verified
    result = result.where(public: true) if @public
    result = result.where(supporter: true) if @supporter

    @characters = result.paginate(page: params[:page])
  end

  def unverify
    character = Character.find(params[:id])

    if character.update!(verified_user_id: nil)
      flash[:success] = "Character is no longer verified."
    else
      flash[:error] = "There was a problem unverifying character."
    end

    redirect_back(fallback_location: root_path)
  end

  def support
    character = Character.find(params[:id])

    if character.update!(supporter: !character.supporter)
      flash[:success] = "Toggled characters's supporter status."
    else
      flash[:error] = "There was a problem toggling the supporter status."
    end

    redirect_back(fallback_location: root_path)
  end
end

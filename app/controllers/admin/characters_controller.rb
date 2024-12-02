class Admin::CharactersController < AdminController
  def index
    @q = Character.all.ransack(params[:q], auth_object: :admin)

    @verified, @public = params.values_at(:verified, :public)
    result = @q.result.includes(:verified_user).order(:created_at)
    result = result.where.not(verified_user_id: nil) if @verified
    result = result.where(public: true) if @public

    @characters = result.paginate(page: params[:page])
  end

  def unverify
    character = Character.find(params[:id])
    name = "#{character.name} of #{character.server}"

    if character.update!(verified_user_id: nil)
      flash[:success] = "#{name} is no longer verified."
    else
      flash[:error] = "There was a problem unverifying #{name}."
    end

    redirect_back(fallback_location: root_path)
  end
end

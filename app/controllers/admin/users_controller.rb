class Admin::UsersController < AdminController
  def index
    @q = User.all.ransack(params[:q])
    @users = @q.result.includes(:character).order(:created_at).paginate(page: params[:page])
  end
end

class Admin::UsersController < AdminController
  def index
    @q = User.all.ransack(params[:q])
    @users = @q.result.order(:created_at).paginate(page: params[:page])
  end
end

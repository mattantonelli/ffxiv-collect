class Admin::GroupsController < AdminController
  def index
    @q = Group.all.ransack(params[:q])
    @groups = @q.result.includes([:characters, :owner]).order(:created_at).paginate(page: params[:page])
  end
end

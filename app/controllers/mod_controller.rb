class ModController < ApplicationController
  before_action :authenticate_mod!
  before_action :set_paper_trail_whodunnit

  def index
    @changes = PaperTrail::Version.includes(:user).order(id: :desc).paginate(page: params[:page])
  end

  private
  def authenticate_mod!
    redirect_to not_found_path unless current_user&.mod?
  end
end

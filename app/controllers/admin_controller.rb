class AdminController < ApplicationController
  before_action :authenticate_admin!

  private
  def authenticate_admin!
    redirect_to not_found_path unless current_user&.admin?
  end
end

class ModController < ApplicationController
  before_action :authenticate_mod!

  private
  def authenticate_mod!
    redirect_to not_found_path unless current_user&.mod?
  end
end

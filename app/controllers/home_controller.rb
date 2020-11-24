class HomeController < ApplicationController
  def index
  end

  def not_found
    flash[:error] = t('alerts.not_found')
    redirect_to root_path
  end
end

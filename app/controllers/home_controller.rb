class HomeController < ApplicationController
  def index
    puts @character
  end

  def not_found
    flash[:error] = 'That page could not be found.'
    redirect_to root_path
  end
end

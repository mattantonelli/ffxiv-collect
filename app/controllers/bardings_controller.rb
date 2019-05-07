class BardingsController < ApplicationController
  def index
    @bardings = Barding.all.order(patch: :desc, id: :desc)
  end
end

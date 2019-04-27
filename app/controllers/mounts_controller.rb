class MountsController < ApplicationController
  def index
    @mounts = Mount.all.order(patch: :desc, order: :desc)
  end

  def show
    @mount = Mount.find(params[:id])
  end
end

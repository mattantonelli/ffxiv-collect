class MountsController < ApplicationController
  include Collection

  def index
    @mounts = Mount.all.order(patch: :desc, order: :desc)
    @mount_ids = @character&.mount_ids || []
  end

  def show
    @mount = Mount.find(params[:id])
  end
end

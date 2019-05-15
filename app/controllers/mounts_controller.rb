class MountsController < ApplicationController
  include Collection

  def index
    @mounts = Mount.includes(sources: :type).order(patch: :desc, order: :desc).all
    @mount_ids = @character&.mount_ids || []
  end

  def show
    @mount = Mount.find(params[:id])
  end
end

class MountsController < ApplicationController
  include Collection

  def index
    @q = Mount.ransack(params[:q])
    @mounts = @q.result.includes(sources: [:type, :related]).with_filters(cookies)
      .order(patch: :desc, order: :desc).distinct
    @types = source_types(:mount)
    @mount_ids = @character&.mount_ids || []
  end

  def show
    @mount = Mount.find(params[:id])
  end
end

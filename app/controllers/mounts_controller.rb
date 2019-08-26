class MountsController < ApplicationController
  include Collection

  def index
    @q = Mount.ransack(params[:q])
    @mounts = @q.result.include_sources.with_filters(cookies)
      .order(patch: :desc, order: :desc).distinct
    @types = source_types(:mount)
  end

  def show
    @mount = Mount.include_sources.find(params[:id])
  end
end

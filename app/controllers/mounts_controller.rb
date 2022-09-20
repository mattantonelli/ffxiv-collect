class MountsController < ApplicationController
  include Collection
  include Attachable

  skip_before_action :set_dates!

  def index
    @q = Mount.ransack(params[:q])
    @mounts = @q.result.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:mount)
  end

  def show
    @mount = Mount.include_sources.find(params[:id])
  end
end

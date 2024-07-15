class FacewearController < ApplicationController
  include PrivateCollection
  before_action -> { check_privacy!(:facewear) }
  skip_before_action :set_dates!

  def index
    @q = Facewear.ransack(params[:q])
    @facewears = @q.result.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:facewear)
  end

  def show
    @facewear = Facewear.include_sources.find(params[:id])
  end
end

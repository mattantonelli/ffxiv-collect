class FacewearController < ApplicationController
  include PrivateCollection
  include Tooltipable

  before_action -> { check_privacy!(:facewear) }, except: :tooltip

  def index
    @q = Facewear.ransack(params[:q])
    @facewears = @q.result.available.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:facewear)
  end

  def show
    @facewear = Facewear.include_sources.find(params[:id])
  end
end

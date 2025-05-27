class OccultRecordsController < ApplicationController
  include ManualCollection
  skip_before_action :set_prices!

  def index
    @q = OccultRecord.ransack(params[:q])
    @records = @q.result.include_related.ordered.distinct
  end

  def show
    @record = OccultRecord.find(params[:id])
  end

  def add
    add_collectable(@character.occult_records, OccultRecord.find(params[:id]))
  end

  def remove
    remove_collectable(@character.occult_records, params[:id])
  end
end

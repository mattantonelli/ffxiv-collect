class FieldRecordsController < ApplicationController
  include ManualCollection
  include Tooltipable

  skip_before_action :set_prices!

  def index
    @q = FieldRecord.ransack(params[:q])
    @records = @q.result.available.include_related.ordered.distinct
  end

  def show
    @record = FieldRecord.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.field_records, FieldRecord.find(params[:id]))
  end

  def remove
    remove_collectable(@character.field_records, params[:id])
  end
end

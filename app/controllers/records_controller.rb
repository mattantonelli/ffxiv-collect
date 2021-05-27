class RecordsController < ApplicationController
  include ManualCollection

  def index
    @q = Record.ransack(params[:q])
    @records = @q.result.include_sources.order(:id).distinct
  end

  def show
    @record = Record.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.records, Record.find(params[:id]))
  end

  def remove
    remove_collectable(@character.records, params[:id])
  end
end

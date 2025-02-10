class Triad::PacksController < ApplicationController
  def index
    @packs = Pack.all.include_related
    @collection_ids = @character&.card_ids || []
    @comparison_ids = @comparison&.card_ids || []
  end
end

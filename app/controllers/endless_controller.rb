class EndlessController < ApplicationController
  def index
    collection = %w(mounts minions emotes bardings hairstyles armoires fashions cards)
      .sample.classify.constantize
    @collectables = collection.all.include_related.to_a.shuffle
    @max_visible = 20
  end
end

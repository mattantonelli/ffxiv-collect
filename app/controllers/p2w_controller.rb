class P2wController < ApplicationController
  def index
    redirect_to p2w_path('mounts')
  end

  def show
    @type = params[:id]
    @types = %w(mounts minions)

    @data = JSON.parse(Redis.current.get("p2w-#{@type.pluralize}"))
    @collectables = @type.classify.constantize.where(id: @data.keys).ordered
    @characters = Character.visible.count

    @owned = {
      count: Redis.current.hgetall("#{@type.pluralize}-count"),
      percentage: Redis.current.hgetall(@type.pluralize)
    }
  end
end

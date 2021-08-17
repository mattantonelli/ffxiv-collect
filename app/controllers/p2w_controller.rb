class P2wController < ApplicationController
  def index
    @prices = JSON.parse(Redis.current.get('p2w-mounts'))
    @mounts = Mount.where(id: @prices.keys).order(patch: :desc, order: :desc)
    @owned = Redis.current.hgetall('mounts')
  end
end

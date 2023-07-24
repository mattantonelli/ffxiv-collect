class P2wController < ApplicationController
  def index
    @data = JSON.parse(Redis.current.get('p2w-mounts'))
    @mounts = Mount.where(id: @data.keys).ordered
    @characters = Character.visible.recent.count
    @owned = {
      count: Redis.current.hgetall('mounts-count'),
      percentage: Redis.current.hgetall('mounts')
    }
  end
end

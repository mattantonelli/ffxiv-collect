class P2wController < ApplicationController
  def index
    @data = JSON.parse(Redis.current.get('p2w-mounts'))
    @mounts = Mount.where(id: @data.keys).order(patch: :desc, order: :desc)
    @characters = Character.visible.recent.count
    @owned = Redis.current.hgetall('mounts')
  end
end

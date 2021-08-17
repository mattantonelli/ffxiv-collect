class P2wController < ApplicationController
  def index
    @mounts = JSON.parse(Redis.current.get('p2w-mounts'))
    @characters = Character.visible.recent.count
    @owned = Redis.current.hgetall('mounts')

    Mount.where(id: @mounts.keys).order(patch: :desc, order: :desc).each do |mount|
      @mounts[mount.id.to_s]['collectable'] = mount
    end
  end
end

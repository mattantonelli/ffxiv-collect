class P2wController < ApplicationController
  def index
    redirect_to p2w_path('mounts')
  end

  def show
    @type = params[:id]
    @types = %w(mounts minions)

    @data = JSON.parse(Redis.current.get("p2w-#{@type.pluralize}"))
    @collectables = @type.classify.constantize.where(id: @data.keys).ordered
    @characters = Redis.current.get('stats-characters')

    @ownership = @collectables.each_with_object({}) do |collectable, h|
      count = @data[collectable.id.to_s]['characters']
      h[collectable.id] = ((count / @characters.to_f) * 100).to_s[0..2].sub(/\.\Z/, '').sub(/0\.0/, '0')
    end
  end
end

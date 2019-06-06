class Mod::ArmoiresController < Mod::CollectablesController
  def index
    @sprite_key = 'armoire'
    super
  end
end

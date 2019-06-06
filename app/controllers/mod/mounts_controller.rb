class Mod::MountsController < Mod::CollectablesController
  def index
    @sprite_key = 'mounts-small'
    super
  end
end

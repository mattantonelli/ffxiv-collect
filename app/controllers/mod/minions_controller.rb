class Mod::MinionsController < Mod::CollectablesController
  def index
    @sprite_key = 'minions-small'
    super
  end
end

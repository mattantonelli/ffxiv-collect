class Mod::FashionsController < Mod::CollectablesController
  def index
    @sprite_key = 'fashions-small'
    super
  end
end

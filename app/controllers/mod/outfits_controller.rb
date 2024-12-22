class Mod::OutfitsController < Mod::CollectablesController
  def index
    @sprite_key = 'outfit'
    super
  end
end

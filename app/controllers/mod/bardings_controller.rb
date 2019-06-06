class Mod::BardingsController < Mod::CollectablesController
  def index
    @sprite_key = 'barding'
    super
  end
end

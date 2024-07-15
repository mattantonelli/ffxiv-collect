class Mod::FacewearController < Mod::CollectablesController
  def index
    @sprite_key = nil
    super
  end
end

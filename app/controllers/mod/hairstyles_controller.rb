class Mod::HairstylesController < Mod::CollectablesController
  def index
    @sprite_key = nil
    super
  end
end

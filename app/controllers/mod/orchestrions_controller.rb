class Mod::OrchestrionsController < Mod::CollectablesController
  def index
    @sprite_key = nil
    super
  end
end

class Mod::OrchestrionsController < Mod::CollectablesController
  before_action :skip_sources, only: [:edit, :update]

  def index
    @sprite_key = nil
    super
  end
end

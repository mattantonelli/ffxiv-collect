class Mod::OccultRecordsController < Mod::CollectablesController
  def index
    @sprite_key = nil
    super
  end
end

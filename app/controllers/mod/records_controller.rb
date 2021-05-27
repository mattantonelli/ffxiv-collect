class Mod::RecordsController < Mod::CollectablesController
  def index
    @sprite_key = 'records-small'
    super
  end
end

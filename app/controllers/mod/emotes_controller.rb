class Mod::EmotesController < Mod::CollectablesController
  def index
    @sprite_key = 'emote'
    super
  end
end

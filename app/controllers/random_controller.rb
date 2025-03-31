class RandomController < ApplicationController
  COLLECTIONS = [
    Achievement, Mount, Minion, Orchestrion, Spell, Hairstyle, Emote, Barding, Armoire, Outfit, Fashion,
    Facewear, Frame, Card, NPC, Record, SurveyRecord
  ].freeze

  def index
    model = COLLECTIONS.sample
    id = model.ids.sample

    redirect_to polymorphic_path(model.find(id))
  end
end

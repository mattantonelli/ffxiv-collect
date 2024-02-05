class Triad::NPCsController < ApplicationController
  include ManualCollection

  def index
    @location = params[:location]
    @rule = params[:rule]
    query = {}

    if @location.present?
      query["location_region_#{I18n.locale}_eq"] = @location
    end

    if @rule.present?
      query["rules_name_#{I18n.locale}_matches_any"] = @rule
    end

    @q = NPC.all.ransack(query)
    @npcs = @q.result.includes(:rewards, :rules, :location, :quest).order(patch: :desc, id: :desc)
    @valid_npcs = @npcs.valid

    if user_signed_in?
      @card_ids = @character.card_ids
      @incomplete = @npcs.joins(:rewards).where('cards.id not in (?)', @card_ids).pluck(:id).uniq
    else
      @card_ids = []
      @incomplete = []
    end
  end

  def show
    if params[:id].match?(/\A\d+\z/)
      @npc = NPC.find(params[:id])
    else
      @npc = NPC.find_by(name_en: params[:id])
    end

    return redirect_to not_found_path unless @npc.present?

    @rewards = @npc.rewards
  end

  def add
    add_collectable(@character.npcs, NPC.find(params[:id]))
  end

  def remove
    remove_collectable(@character.npcs, params[:id])
  end

  def update_defeated
    if @character&.verified_user?(current_user)
      npc_ids = NPC.defeated_npcs(@character)
      @character.set_npcs(npc_ids)
      redirect_to npcs_path
    end
  end
end

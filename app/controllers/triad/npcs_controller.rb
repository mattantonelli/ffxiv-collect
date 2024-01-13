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
      @user_cards = current_user.cards.pluck(:id)
      @incomplete = @npcs.joins(:rewards).where('cards.id not in (?)', @user_cards).pluck(:id).uniq
      @defeated = current_user.npcs.pluck(:id)
      @total = @valid_npcs.present? ? @valid_npcs.count : NPC.count
      @count = (@defeated & @valid_npcs.pluck(:id)).count
    else
      render_sign_in_flash
      @user_cards = []
      @incomplete = []
      @defeated = []
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
    current_user.add_defeated_npcs
    redirect_to npcs_path
  end

  private
  def set_params
    params.permit(:npcs)
  end
end

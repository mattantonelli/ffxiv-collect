class Triad::DecksController < ApplicationController
  before_action :set_deck, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :set_user_cards, only: [:index, :mine, :show]
  before_action :signed_in?, except: [:index, :show]
  before_action :authenticated?, only: [:edit, :update, :destroy], unless: :admin?
  before_action :filter_query, only: [:index, :mine]

  def index
    @q = Deck.ransack(params[:q])
    @decks = @q.result.includes(:user, :rule, :npc, :cards).order(rating: :desc, id: :desc).paginate(page: params[:page])
  end

  def mine
    @q = current_user.decks.ransack(params[:q])
    @decks = @q.result.includes(:user, :rule, :npc, :cards).order(rating: :desc, id: :desc).paginate(page: params[:page])
    render :index
  end

  def show
    @user_card_ids = Card.where(id: @user_cards).order(:deck_order, :id).pluck(:id) if user_signed_in?
  end

  def new
    @deck = Deck.new(npc_id: params[:npc_id])
    set_search_and_cards
    set_new_edit_responses
  end

  def create
    @deck = current_user.decks.new(deck_params)

    if @deck.save
      redirect_to deck_path(@deck)
    else
      set_search_and_cards
      flash_errors(@deck)
      render :new
    end
  end

  def edit
    @deck = Deck.find(params[:id])
    set_search_and_cards
    set_new_edit_responses
    render :new
  end

  def update
    @deck.transaction do
      if @deck.card_ids != deck_params[:card_ids]
        @deck.deck_cards.delete_all
      end

      if @deck.update(deck_params)
        flash[:success] = 'The deck has been updated successfully.'
        redirect_to deck_path(@deck)
      else
        set_search_and_cards
        flash_errors(@deck)
        render :new
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy
    if @deck.destroy
      flash[:success] = 'The deck has been deleted successfully.'
    else
      flash[:error] = 'The deck could not be deleted.'
    end

    redirect_to decks_path
  end

  def upvote
    if @deck.upvote(current_user)
      flash[:success] = 'Your vote has been added.'
    else
      flash[:error] = 'There was a problem casting your vote.'
    end

    redirect_to deck_path(@deck)
  end

  def downvote
    if @deck.downvote(current_user)
      flash[:success] = 'Your vote has been removed.'
    else
      flash[:error] = 'There was a problem removing your vote.'
    end

    redirect_to deck_path(@deck)
  end

  private
  def set_deck
    @deck = Deck.find(params[:id] || params[:deck_id])
  end

  def set_user_cards
    @user_cards = current_user.cards.pluck(:id) if user_signed_in?
  end

  def authenticated?
    redirect_to decks_path unless @deck.user_id == current_user.id
  end

  def signed_in?
    unless user_signed_in?
      flash[:alert] = 'You must sign in to manage your decks.'
      redirect_to decks_path
    end
  end

  def admin?
    current_user&.admin?
  end


  def set_search_and_cards
    unless params[:source] == 'deck'
      @q = Card.ransack(params[:q])

      if params[:source] == 'search'
        @cards = @q.result.includes(:type).order(patch: :desc, order_group: :desc, order: :desc)
      else
        @cards = Card.includes(:type).order(patch: :desc, order_group: :desc, order: :desc).first(5)
      end
    end

    if ids = params[:card_ids]
      @deck.card_ids = ids.split(',')
    end
  end

  def set_new_edit_responses
    respond_to do |format|
      format.html
      format.js do
        case params[:source]
        when 'deck' then render 'deck_cards'
        when 'search' then render 'search_results'
        end
      end
    end
  end

  def filter_query
    params[:q] ||= {}

    if params[:general].present?
      params[:q].merge!(rule_id_null: true, npc_id_null: true)
    end

    if params[:updated].present?
      params[:q].merge!(updated_true: 1)
    end
  end

  def deck_params
    parms = params.require(:deck).permit(:card_ids, :rule_id, :npc_id, :notes)
    parms[:card_ids] = parms[:card_ids].split(',').map(&:to_i)
    parms
  end
end

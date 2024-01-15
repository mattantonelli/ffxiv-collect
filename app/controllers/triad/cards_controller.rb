class Triad::CardsController < ApplicationController
  include ManualCollection
  before_action :verify_user!, only: [:select, :set]

  def index
    @q = Card.ransack(params[:q])
    @cards = @q.result.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:card)
  end

  def select
    @cards = Card.all.order(:order_group, :order)
    @owned_cards = @character.card_ids
  end

  def show
    if params[:id].match?(/\A\d+\z/)
      @card = Card.find(params[:id])
    else
      @card = Card.find_by(name_en: params[:id])
    end

    redirect_to not_found_path unless @card.present?
  end

  def add
    add_collectable(@character.cards, Card.find(params[:id]))
  end

  def remove
    remove_collectable(@character.cards, params[:id])
  end

  def set
    @character.card_ids = set_params[:cards].split(',')
    redirect_to cards_path
  end

  def no
    if card = Card.no(params[:id])
      redirect_to card_path(card)
    else
      flash[:error] = t('alerts.not_found')
      redirect_to cards_path
    end
  end

  def ex
    if card = Card.ex(params[:id])
      redirect_to card_path(card)
    else
      flash[:error] = t('alerts.not_found')
      redirect_to cards_path
    end
  end

  private
  def set_params
    params.permit(:cards)
  end

  def verify_user!
    if !user_signed_in? || !@character&.verified_user?(current_user)
      link = view_context.link_to(t('alerts.signed_in'), user_discord_omniauth_authorize_path, method: :post)
      flash[:alert] = t('alerts.sign_in_to_track', link: link)
      redirect_to cards_path
    end
  end
end

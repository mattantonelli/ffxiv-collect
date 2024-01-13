class Triad::PacksController < ApplicationController
  def index
    @packs = Pack.all.includes(cards: :type)
    @owned_cards = current_user.cards.pluck(:id) if user_signed_in?
  end
end

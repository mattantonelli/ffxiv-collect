class Triad::ImportController < ApplicationController
  before_action :verify_user!

  def index
    @uid = params[:uid] || current_user.uid

    begin
      @collection = AnotherTripleTriadTracker.user(@uid)
    rescue RestClient::Forbidden
      @forbidden = true
    rescue RestClient::NotFound
    rescue
      Rails.logger.error("Could not query the ATTT API for user #{@uid}")
      flash.now[:error] = t('triad.import.error')
    end
  end

  def execute
    @character.transaction do
      begin
        @character.import_triple_triad_progress!(card_ids: params[:card_ids].split(' '),
                                                 npc_ids: params[:npc_ids].split(' '))
        flash[:success] = t('triad.import.success')
      rescue
        Rails.logger.error("Could not import ATTT progress for character #{@character.id} " \
                           "with user #{params[:uid]}")
        flash[:error] = t('triad.import.error')
        raise ActiveRecord::Rollback
      end
    end

    redirect_to cards_path
  end
end

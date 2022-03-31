class CharactersController < ApplicationController
  before_action :verify_signed_in!, only: [:verify, :validate, :destroy]
  before_action :confirm_unverified!, :set_code, only: [:verify, :validate]
  before_action :set_profile, only: [:show, :stats_recent, :stats_rarity]
  before_action :verify_privacy!, only: [:show, :stats_recent, :stats_rarity]

  COLLECTIONS = %w(achievements mounts minions orchestrions spells emotes bardings hairstyles armoires fashions records).freeze
  STATS_COLLECTIONS = COLLECTIONS.dup.insert(1, 'titles').freeze

  def show
    if @profile != @character && @profile.syncable?
      @profile.sync
    end

    @triad = @profile.triple_triad

    @scores = COLLECTIONS.each_with_object({}) do |collection, h|
      next unless @profile.send("#{collection}_count") > 0

      ids = collection.classify.constantize.with_filters(cookies, @profile).pluck(:id)
      ids -= Minion.unsummonable_ids if collection == 'minions'
      owned_ids = @profile.send("#{collection.singularize}_ids")
      h[collection] = { value: (owned_ids & ids).size, max: ids.size }

      if collection == 'achievements'
        h[collection][:points] = Achievement.with_filters(cookies, @profile).joins(:character_achievements)
          .where('character_achievements.character_id = ?', @profile).sum(:points)
        h[collection][:points_max] = Achievement.with_filters(cookies, @profile).sum(:points)
      end
    end

    # Add relic scores
    @scores['relics'] = {}
    owned_relic_ids = @profile.relic_ids

    Relic.categories.each do |category|
      ids = Relic.joins(:type).where('relic_types.category = ?', category).pluck(:id)
      @scores['relics'][category] = { value: (owned_relic_ids & ids).size, max: ids.size }
    end
  end

  def profile
    if @character.present?
      redirect_to(action: :show, id: @character.id)
    else
      redirect_to root_path
    end
  end

  def stats_recent
    @collections = STATS_COLLECTIONS.each_with_object({}) do |collection, h|
      h[collection] = @profile.most_recent(collection, filters: cookies)
    end
  end

  def stats_rarity
    @collections = STATS_COLLECTIONS.each_with_object({}) do |collection, h|
      h[collection] = @profile.most_rare(collection, filters: cookies)
    end
  end

  def search
    @name, @server, @id = params.values_at(:name, :server, :id)
    @search = @server.present? && @name.present?

    if @search
      begin
        @characters = Lodestone.search(@name, @server)
        if @characters.empty?
          flash.now[:alert] = t('alerts.no_characters_found')
        end
      rescue RestClient::BadGateway, RestClient::ServiceUnavailable
        flash.now[:error] = t('alerts.lodestone_maintenance')
      rescue Exception => e
        flash.now[:error] = t('alerts.lodestone_error')
        Rails.logger.error("There was a problem searching for \"#{@name}\" on \"#{@server}\"")
        log_backtrace(e)
      end
    elsif @id
      select
    else
      if user_signed_in?
        @characters = current_user.characters.order(:server, :name).to_a
          .sort_by { |character| character.verified_user_id == current_user.id ? 0 : 1 }
      end
    end
  end

  def select
    begin
      character = Character.find_by(id: params[:id]) || fetch_character(params[:id])
    rescue
      # The exception has been logged in the fetch. Now let the following logic alert the user.
    end

    if !character.present?
      flash[:error] = t('alerts.problem_selecting_character')
      redirect_back(fallback_location: root_path)
    elsif character.private?(current_user)
      flash[:alert] = t('alerts.private_character')
      redirect_back(fallback_location: root_path)
    else
      if params[:compare]
        set_permanent_cookie(:comparison, params[:id])
      elsif user_signed_in?
        current_user.update(character_id: params[:id])
      else
        set_permanent_cookie(:character, params[:id])
      end

      if user_signed_in?
        current_user.characters << character unless current_user.characters.exists?(character.id)
      end

      unless flash[:notice].present?
        if params[:compare]
          flash[:success] = t('alerts.comparison_set')
        else
          flash[:success] = t('alerts.character_set')
        end
      end

      redirect_to character_path(character)
    end
  end

  def forget
    if user_signed_in?
      current_user.update(character_id: nil)
    else
      cookies.delete(:character)
    end

    flash[:success] = t('alerts.no_longer_tracking')
    redirect_to root_path
  end

  def forget_comparison
    cookies.delete(:comparison)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.characters.delete(params[:id])
    redirect_to search_characters_path(({ compare: 1 } if params[:compare]))
  end

  def refresh
    if !@character.refreshable?
      flash[:alert] = t('alerts.already_refreshed')
    elsif @character.in_queue?
      flash[:alert] = t('alerts.character_syncing')
    else
      begin
        character = fetch_character(@character.id)

        if character.present?
          character.update(refreshed_at: Time.now)
          flash[:success] = t('alerts.character_refreshed')
        else
          flash[:error] = t('alerts.lodestone_error')
        end
      rescue RestClient::BadGateway, RestClient::ServiceUnavailable
        flash[:error] = t('alerts.lodestone_maintenance')
      rescue
        flash[:error] = t('alerts.problem_refreshing')
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def verify
    session[:return_to] = request.referer
  end

  def validate
    begin
      if @character.verify!(current_user)
        flash[:success] = t('alerts.character_verified')
        redirect_to_previous
      else
        flash[:error] = t('alerts.character_verification_error')
        render :verify
      end
    rescue Exception => e
      flash[:error] = t('alerts.problem_verifying')
      Rails.logger.error("There was a problem verifying character #{@character.id}")
      log_backtrace(e)
      render :verify
    end
  end

  private
  def set_code
    @code = @character.verification_code(current_user)
  end

  def set_profile
    @profile = Character.find_by(id: params[:id])

    unless @profile.present?
      flash[:error] = t('alerts.character_not_found')
      redirect_to root_path
    end
  end

  def confirm_unverified!
    if @character.verified_user?(current_user)
      flash[:alert] = t('alerts.character_already_verified')
      redirect_to root_path
    end
  end

  def verify_privacy!
    unless @profile.public? || @profile.verified_user?(current_user)
      flash[:error] = t('alerts.private_character')
      redirect_back(fallback_location: root_path)
    end
  end

  def fetch_character(id)
    begin
      Character.fetch(id)
    rescue RestClient::BadGateway, RestClient::ServiceUnavailable
      Rails.logger.info('Lodestone is down for maintenance.')
      raise
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("There was a problem fetching character #{id}")
      Rails.logger.error(e.response)
      raise
    rescue Exception => e
      Rails.logger.error("There was a problem fetching character #{id}")
      log_backtrace(e)
      raise
    end
  end
end

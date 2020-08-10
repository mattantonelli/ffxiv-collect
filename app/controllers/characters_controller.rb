class CharactersController < ApplicationController
  before_action :verify_signed_in!, only: [:verify, :validate, :destroy]
  before_action :confirm_unverified!, :set_code, only: [:verify, :validate]
  before_action :set_profile, only: [:show, :stats_recent, :stats_rarity]
  before_action :verify_privacy!, only: [:show, :stats_recent, :stats_rarity]

  COLLECTIONS = %w(achievements mounts minions orchestrions spells emotes bardings hairstyles armoires).freeze

  def show
    if @profile.stale? && !@profile.in_queue?
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
  end

  def profile
    if @character.present?
      redirect_to(action: :show, id: @character.id)
    else
      redirect_to root_path
    end
  end

  def stats_recent
    @collections = COLLECTIONS.each_with_object({}) do |collection, h|
      h[collection] = @profile.most_recent(collection)
    end
  end

  def stats_rarity
    @collections = COLLECTIONS.each_with_object({}) do |collection, h|
      h[collection] = @profile.most_rare(collection)
    end
  end

  def search
    @server, @name = params.values_at(:server, :name)
    @search = @server.present? && @name.present?

    if @search
      begin
        @characters = Character.search(@server, @name)
        if @characters.empty?
          flash.now[:alert] = 'No characters found.'
        end
      rescue Exception => e
        flash.now[:error] = 'There was a problem contacting the Lodestone.'
        Rails.logger.error("There was a problem searching for \"#{@name}\" on \"#{@server}\"")
        log_backtrace(e)
      end
    else
      if user_signed_in?
        @characters = current_user.characters.order(:server, :name).to_a
          .sort_by { |character| character.verified_user_id == current_user.id ? 0 : 1 }
      end
    end
  end

  def select
    character = Character.find_by(id: params[:id])

    # For new characters, retrieve their basic data and queue them for a full sync
    unless character.present?
      begin
        character = fetch_character(params[:id], basic: true)
        character.sync
        flash[:notice] = 'Your collection data is being retrieved from the Lodestone. Please check back in a minute.'
      rescue
        # The exception has been logged in the fetch. Now let the following logic alert the user.
      end
    end

    if !character.present?
      flash[:error] = 'There was a problem selecting that character.'
      redirect_back(fallback_location: root_path)
    elsif character.private?(current_user)
      flash[:alert] = "Sorry, this character's verified user has set their collections to private."
      redirect_back(fallback_location: root_path)
    else
      if params[:compare]
        cookies[:comparison] = params[:id]
      elsif user_signed_in?
        current_user.update(character_id: params[:id])
      else
        cookies[:character] = params[:id]
      end

      if user_signed_in?
        current_user.characters << character unless current_user.characters.exists?(character.id)
      end

      unless flash[:notice].present?
        flash[:success] = "Your #{'comparison ' if params[:compare]}character has been set."
      end

      redirect_to character_path(character)
    end
  end

  def forget
    if user_signed_in?
      current_user.update(character_id: nil)
    else
      cookies[:character] = nil
    end

    flash[:success] = 'You are no longer tracking a character.'
    redirect_to root_path
  end

  def forget_comparison
    cookies[:comparison] = nil
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.characters.delete(params[:id])
    redirect_to search_characters_path(({ compare: 1 } if params[:compare]))
  end

  def refresh
    if @character.in_queue?
      flash[:alert] = 'Your character has already been refreshed in the past 30 minutes. Please try again later.'
    else
      begin
        character = fetch_character(@character.id)

        if character.present?
          character.update(queued_at: Time.now)
          flash[:success] = 'Your character has been refreshed.'
        else
          flash[:error] = 'There was a problem contacting the Lodestone.'
        end
      rescue
        flash[:error] = 'There was a problem refreshing your character.'
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
        flash[:success] = 'Your character has been verified. You can now remove the code from your profile.'
        redirect_to_previous
      else
        flash[:error] = 'Your character could not be verified. Please check your profile and try again.'
        render :verify
      end
    rescue Exception => e
      flash[:error] = 'There was a problem verifying your character.'
      Rails.logger.error("There was a problem verifying character #{id}")
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
      flash[:error] = 'Character could not be found.'
      redirect_to root_path
    end
  end

  def confirm_unverified!
    if @character.verified_user?(current_user)
      flash[:alert] = 'Your character has already been verified.'
      redirect_to root_path
    end
  end

  def verify_privacy!
    unless @profile.public? || @profile.verified_user?(current_user)
      flash[:error] = "This character's profile has been set to private."
      redirect_back(fallback_location: root_path)
    end
  end

  def fetch_character(id, basic: false)
    begin
      Character.fetch(id, basic: basic)
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

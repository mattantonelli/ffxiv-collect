class GroupsController < ApplicationController
  before_action :set_group, except: [:index, :new, :create]
  before_action :verify_ownership!, only: [:edit, :update, :destroy, :manage, :add_character, :remove_character]
  before_action :verify_signed_in!, only: [:index]
  include CharacterGroup

  def index
    @groups = current_user.owned_groups.ordered.includes(:characters)
  end

  def show
    super
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user

    if @group.save
      flash[:success] = t('alerts.groups.create_success')
      redirect_to manage_group_path(@group)
    else
      flash.now[:error] = t('alerts.groups.create_failure')
      render :new
    end
  end

  def update
    if @group.update!(group_params)
      flash[:success] = t('alerts.groups.update_success')
      redirect_to groups_path
    else
      flash.now[:error] = t('alerts.groups.update_failure')
      render :edit
    end
  end

  def manage
  end

  def character_search
    begin
      search_params = params.permit(:id, :name, :server, :data_center)

      @characters = Character.where('name like ?', "%#{search_params[:name]}%").limit(10)

      %i(data_center server).each do |param|
        value = search_params[param]
        @characters = @characters.where(param => value) if value.present?
      end

      @characters = @characters.to_a.sort_by(&:name)
    rescue
      flash[:error] = t('alerts.groups.search_failure')
      redirect_to manage_group_path(@group)
    end
  end

  def add_character
    if @group.characters.size >= 100
      flash[:error] = t('alerts.groups.character_limit')
      redirect_to manage_group_path(@group)
    elsif !@group.character_ids.include?(params[:character_id].to_i)
      begin
        @group.add_character(Character.find(params[:character_id]))
        @characters = @group.characters.order(:name)
        render 'refresh_characters'
      rescue
        flash[:error] = t('alerts.groups.add_character_failure')
        redirect_to manage_group_path(@group)
      end
    end
  end

  def remove_character
    begin
      @group.remove_character(Character.find(params[:character_id]))
      @characters = @group.characters.order(:name)
      render 'refresh_characters'
    rescue
      flash[:error] = t('alerts.groups.remove_character_failure')
      redirect_to manage_group_path(@group)
    end
  end

  def destroy
    if @group.destroy
      flash[:success] = t('alerts.groups.delete_success')
    else
      flash[:error] = t('alerts.groups.delete_failure')
    end

    redirect_to groups_path
  end

  private
  def set_group
    @group = Group.friendly.find(params[:id] || params[:group_id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :public)
  end

  def verify_ownership!
    unless @group.owner == current_user
      flash[:error] = t('alerts.groups.permission_failure')
      redirect_to groups_path
    end
  end
end

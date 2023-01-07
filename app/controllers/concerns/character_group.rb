module CharacterGroup
  extend ActiveSupport::Concern

  included do
    before_action :set_members, only: [:show, :mounts]
    before_action :verify_group_membership!, only: [:show, :mounts, :refresh]
  end

  def show
    render 'groups/show'
  end

  def mounts
    @collection = 'mounts'
    @sprite_key = 'mounts-small'
    @collectables = Mount.joins(sources: :type)
      .where('source_types.name in (?)', %w(Trial Raid))
      .order('source_types.name DESC, mounts.patch ASC')
      .distinct.group_by(&:expansion)

    @owned_ids = CharacterMount.where(character_id: @members)
      .each_with_object(Hash.new { |k, v| k[v] = [] }) do |char, h|
        h[char.character_id] << char.mount_id
      end

    render 'groups/collection'
  end

  def refresh
    if @group.in_queue?
      flash[:alert] = t('alerts.groups.syncing')
    elsif !@group.syncable?
      flash[:alert] = t('alerts.groups.already_refreshed')
    else
      begin
        @group.refresh
        flash[:success] = t('alerts.groups.refreshed')
      rescue ActiveJob::Uniqueness::JobNotUnique
        flash[:alert] = t('alerts.groups.syncing')
      end
    end

    redirect_to polymorphic_path(@group)
  end

  private
  def set_members
    @members = @group.members.visible.order(:name)
  end
end

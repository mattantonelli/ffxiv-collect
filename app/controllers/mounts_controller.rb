class MountsController < ApplicationController
  include Collection

  def index
    @q = Mount.ransack(params[:q])
    @mounts = @q.result.include_sources.with_filters(cookies)
      .order(patch: :desc, order: :desc).distinct
    @types = source_types(:mount)
    @mount_ids = @character&.mount_ids || []

    if @character.present?
      flash.now[:alert_fixed] = 'Due to changes on the Lodestone, mount and minion sync are temporarily disabled. ' \
        "Please check the #{view_context.link_to('Discord', 'https://discord.gg/m5x5S2a')} for details."
    end
  end

  def show
    @mount = Mount.include_sources.find(params[:id])
  end
end

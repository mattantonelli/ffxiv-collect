class Mod::MountsController < ModController
  before_action :set_mount, only: [:edit, :update]
  before_action :set_changes, only: [:edit, :update]

  def index
    @q = Mount.all.ransack(params[:q])
    @mounts = @q.result.includes(sources: [:type, :related]).order(patch: :desc, order: :desc).paginate(page: params[:page])
  end

  def edit
    build_sources
  end

  def update
    update_params = mount_params
    update_params[:sources_attributes].reject! { |_, source| source[:type_id].blank? }

    update_params[:sources_attributes].each do |key, source|
      type = SourceType.find(source[:type_id])
      case type.name
      when /(Achievement|Quest)/
        related = type.name.constantize.find_by(name_en: source[:text])
        update_params[:sources_attributes][key].merge!(related_id: related&.id, related_type: type.name)
      when /(Dungeon|Trial|Raid)/
        related = Instance.find_by(name_en: source[:text])
        update_params[:sources_attributes][key].merge!(related_id: related&.id, related_type: 'Instance')
      end
    end

    if @mount.update(update_params)
      flash[:success] = 'The mount has been updated.'
      redirect_to edit_mod_mount_path(@mount)
    else
      flash[:error] = 'There was a problem updating the mount.'
      build_sources
      render :edit
    end
  end

  private
  def set_mount
    @mount = Mount.find(params[:id])
  end

  def set_changes
    @changes = PaperTrail::Version.where(collectable_type: 'Mount', collectable_id: 186)
      .or(PaperTrail::Version.where(item_type: 'Mount', item_id: 186)).order(id: :desc)
  end

  def build_sources
    2.times { @mount.sources.build }
  end

  def mount_params
    params.require(:mount).permit(:name_en, :patch, sources_attributes: [:id, :type_id, :collectable_id, :collectable_type, :text])
  end
end

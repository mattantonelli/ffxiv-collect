class Admin::VersionsController < AdminController
  def revert
    version = PaperTrail::Version.find(params[:version_id])

    if version.event == 'create'
      version.item_type.constantize.find_by(id: version.item_id)&.destroy
    else
      PaperTrail::Version.find(params[:version_id]).reify.save
    end

    redirect_back(fallback_location: root_path)
  end
end

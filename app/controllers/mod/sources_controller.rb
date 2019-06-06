class Mod::SourcesController < ModController
  def destroy
    if Source.find(params[:id]).destroy
      flash[:success] = 'The mount has been updated.'
    else
      flash[:error] = 'There was a problem updating the mount.'
    end

    redirect_back(fallback_location: root_path)
  end
end

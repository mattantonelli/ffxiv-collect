class Mod::SourcesController < ModController
  def destroy
    if Source.find(params[:id]).destroy
      flash[:success] = 'The source has been deleted.'
    else
      flash[:error] = 'There was a problem deleting the source.'
    end

    redirect_back(fallback_location: root_path)
  end
end

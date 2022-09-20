module Attachable
  extend ActiveSupport::Concern

  def update
    @collectable = controller_name.classify.constantize.find(params[:id])
    key = controller_name.singularize

    if @collectable.screenshots.attach(params.require(key)[:screenshot])
      flash[:success] = t('alerts.screenshot_added')
    else
      flash[:error] = t('alerts.screenshot_error')
    end

    redirect_to polymorphic_path(@collectable)
  end
end

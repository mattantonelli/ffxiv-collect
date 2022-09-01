class FreeCompaniesController < ApplicationController
  before_action :set_free_company

  def show
    @members = @free_company.members.order(:name)
  end

  def refresh
    if @free_company.in_queue?
      flash[:alert] = t('alerts.free_company_syncing')
    elsif !@free_company.syncable?
      flash[:alert] = t('alerts.free_company_already_refreshed')
    else
      begin
        FreeCompanySyncJob.perform_later(@free_company.id)
        flash[:success] = t('alerts.free_company_refreshed')
      rescue ActiveJob::Uniqueness::JobNotUnique
        flash[:alert] = t('alerts.free_company_syncing')
      end
    end

    redirect_to free_company_path(@free_company)
  end

  private
  def set_free_company
    @free_company = FreeCompany.find(params[:id])
  end
end

module FreeCompaniesHelper
  def free_company_refreshable?(free_company)
    @free_company.syncable? && !@free_company.in_queue?
  end
end

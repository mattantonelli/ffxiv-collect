class FreeCompaniesController < ApplicationController
  before_action :set_group
  include CharacterGroup
  skip_before_action :verify_group_membership!

  def show
    super
  end

  private
  def set_group
    @group = FreeCompany.find(params[:id] || params[:free_company_id])
  end

  def set_members
    @members = @group.members.order(:name)
  end
end

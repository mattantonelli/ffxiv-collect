# == Schema Information
#
# Table name: free_companies
#
#  id         :string(255)      not null, primary key
#  name       :string(255)
#  queued_at  :datetime         default(1970-01-01 00:00:00.000000000 UTC +00:00)
#  syncing    :boolean          default(FALSE)
#  tag        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FreeCompany < ApplicationRecord
  include Syncable

  has_many :characters
  alias_method :members, :characters

  def formatted_name
    if tag.present?
      "#{name} «#{tag}»"
    else
      name
    end
  end

  def refresh
    update!(queued_at: Time.now, syncing: true)
    FreeCompanySyncJob.perform_async(id)
  end

  def self.fetch(id)
    data = Lodestone.free_company(id)
    return nil unless data.present?

    if free_company = FreeCompany.find_by(id: id)
      free_company.update!(data)
    else
      free_company = FreeCompany.create!(data)
    end

    free_company
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(slug)
  end
end

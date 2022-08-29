# == Schema Information
#
# Table name: free_companies
#
#  id         :string(255)      not null, primary key
#  name       :string(255)
#  tag        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FreeCompany < ApplicationRecord
  include Queueable

  has_many :members, class_name: 'Character'

  def self.fetch(id)
    data = Lodestone.free_company(id)

    if free_company = FreeCompany.find_by(id: id)
      free_company.update!(data)
    else
      free_company = FreeCompany.create!(data)
    end

    free_company
  end

  def expire!
    members.first.expire!
  end

  def formatted_name
    if tag.present?
      "#{name} <#{tag}>"
    else
      name
    end
  end

  def syncable?
    members.any?(&:syncable?) && !in_queue?
  end

  def sync_members
    FreeCompanySyncJob.perform_later(id)
  end
end

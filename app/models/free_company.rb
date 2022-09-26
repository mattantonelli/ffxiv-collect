# == Schema Information
#
# Table name: free_companies
#
#  id         :string(255)      not null, primary key
#  name       :string(255)
#  tag        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  queued_at  :datetime         default(Thu, 01 Jan 1970 00:00:00.000000000 UTC +00:00)
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
    update!(queued_at: Time.at(0))
  end

  def formatted_name
    if tag.present?
      "#{name} «#{tag}»"
    else
      name
    end
  end

  def recently_queued?
    queued_at > Time.now - 5.seconds
  end

  def syncable?
    !recently_queued? && !in_queue? && (!up_to_date? || queued_at < Time.now - 6.hours)
  end

  def sync_members
    update(queued_at: Time.now)
    FreeCompanySyncJob.perform_later(id)
  end

  def up_to_date?
    members.none?(&:stale?)
  end
end

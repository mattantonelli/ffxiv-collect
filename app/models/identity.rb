# == Schema Information
#
# Table name: identities
#
#  id         :bigint           not null, primary key
#  avatar_url :string(255)
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  username   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
class Identity < ApplicationRecord
  belongs_to :user

  def formatted_provider
    Identity.formatted_provider(provider)
  end

  def self.formatted_provider(provider)
    case provider.to_s
    when 'google_oauth2'
      'Google'
    when 'xivauth'
      'XIVAuth'
    else
      provider.to_s.capitalize
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    if auth_object == :admin
      %w(username uid)
    else
      []
    end
  end
end

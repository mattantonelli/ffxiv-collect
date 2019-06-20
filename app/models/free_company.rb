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
  has_many :members, class_name: 'Character'
end

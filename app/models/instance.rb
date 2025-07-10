# == Schema Information
#
# Table name: instances
#
#  id              :bigint(8)        not null, primary key
#  name_en         :string(255)      not null
#  name_de         :string(255)      not null
#  name_fr         :string(255)      not null
#  name_ja         :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  content_type_id :integer          not null
#

class Instance < ApplicationRecord
  translates :name

  belongs_to :content_type

  def self.ransackable_attributes(auth_object = nil)
    super + %w(content_type)
  end
end

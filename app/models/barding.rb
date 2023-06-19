# == Schema Information
#
# Table name: bardings
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  patch          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  description_en :string(255)
#  description_de :string(255)
#  description_fr :string(255)
#  description_ja :string(255)
#  order          :integer
#

class Barding < ApplicationRecord
  include Collectable
  translates :name, :description

  scope :include_related, -> { include_sources }
  scope :ordered, -> { order(patch: :desc, order: :desc) }

  def self.available_filters
    %i(owned tradeable premium limited unknown)
  end
end

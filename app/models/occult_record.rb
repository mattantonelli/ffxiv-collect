# == Schema Information
#
# Table name: occult_records
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)
#  name_de        :string(255)
#  name_fr        :string(255)
#  name_ja        :string(255)
#  description_en :text(65535)
#  description_de :text(65535)
#  description_fr :text(65535)
#  description_ja :text(65535)
#  patch          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class OccultRecord < ApplicationRecord
  include Collectable

  translates :name, :description

  alias_attribute :order, :id

  scope :include_related, -> { include_sources }
  scope :ordered, -> { order(:id) }

  def self.available_filters
    %i(owned)
  end
end

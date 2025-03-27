# == Schema Information
#
# Table name: fashions
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  description_en :string(1000)
#  description_de :string(1000)
#  description_fr :string(1000)
#  description_ja :string(1000)
#  order          :integer          not null
#  patch          :string(255)
#  item_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Fashion < ApplicationRecord
  include Collectable
  translates :name, :description

  scope :include_related, -> { include_sources }
  scope :ordered, -> { order(patch: :desc, order: :desc) }

  # IDs of fashion accessories that were migrated to facewear
  def self.facewear_ids
    Rails.application.config_for(:fashions).facewear_ids.freeze
  end

  def self.available_filters
    %i(owned tradeable premium limited unknown)
  end
end

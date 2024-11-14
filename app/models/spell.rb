# == Schema Information
#
# Table name: spells
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)      not null
#  name_de        :string(255)      not null
#  name_fr        :string(255)      not null
#  name_ja        :string(255)      not null
#  description_en :string(1000)     not null
#  description_de :string(1000)     not null
#  description_fr :string(1000)     not null
#  description_ja :string(1000)     not null
#  tooltip_en     :string(1000)     not null
#  tooltip_de     :string(1000)     not null
#  tooltip_fr     :string(1000)     not null
#  tooltip_ja     :string(1000)     not null
#  order          :integer
#  rank           :integer          not null
#  patch          :string(255)
#  type_id        :integer          not null
#  aspect_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Spell < ApplicationRecord
  include Collectable
  translates :name, :description, :tooltip

  belongs_to :type, class_name: 'SpellType'
  belongs_to :aspect, class_name: 'SpellAspect'

  scope :include_related, -> { include_sources.includes(:type, :aspect) }
  scope :ordered, -> { order(order: :desc) }

  def self.available_filters
    %i(owned)
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(rank)
  end

  def self.ransackable_associations(auth_object = nil)
    super + %w(aspect)
  end
end

# == Schema Information
#
# Table name: items
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
#  icon_id        :string(6)
#  tradeable      :boolean
#  unlock_type    :string(255)
#  unlock_id      :integer
#  crafter        :string(255)
#  recipe_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  price          :integer
#  plural_en      :string(255)
#  plural_de      :string(255)
#  plural_fr      :string(255)
#  plural_ja      :string(255)
#  quest_id       :integer
#
class Item < ApplicationRecord
  translates :name, :description, :plural

  belongs_to :unlock, polymorphic: true, required: false
  belongs_to :quest, required: false
  has_many :outfit_items
  has_many :outfits, through: :outfit_items

  scope :collectable, -> { where.not(unlock_id: nil) }
  scope :tradeable, -> { where(tradeable: true) }

  def tomestone_name(locale: :en)
    name = attributes["name_#{locale}"]

    case locale
    when :en
      name.sub(/.+ Of (.+)/, '\1')
    when :de
      name.sub(/.+ De[rs] (.+)/, '\1')
    when :fr
      name.sub(/.+ Inhabituel (.+)/, '\1\2')
    when :ja
      name.sub(/.+:(.+)/, '\1')
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(
      plural_en plural_de plura_fr plural_ja
      tradeable crafter price unlock_type
      unlock_id recipe_id quest_id
    )
  end

  def self.ransackable_associations(auth_object = nil)
    %w(unlock)
  end
end

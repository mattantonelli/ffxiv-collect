# == Schema Information
#
# Table name: mounts
#
#  id                      :bigint(8)        not null, primary key
#  name_en                 :string(255)      not null
#  name_de                 :string(255)      not null
#  name_fr                 :string(255)      not null
#  name_ja                 :string(255)      not null
#  order                   :integer          not null
#  patch                   :string(255)
#  description_en          :string(255)      not null
#  description_de          :string(255)      not null
#  description_fr          :string(255)      not null
#  description_ja          :string(255)      not null
#  enhanced_description_en :string(1000)     not null
#  enhanced_description_de :string(1000)     not null
#  enhanced_description_fr :string(1000)     not null
#  enhanced_description_ja :string(1000)     not null
#  tooltip_en              :string(255)      not null
#  tooltip_de              :string(255)      not null
#  tooltip_fr              :string(255)      not null
#  tooltip_ja              :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  movement                :string(255)      not null
#  seats                   :integer          not null
#  item_id                 :integer
#  video                   :string(255)
#  order_group             :integer
#  bgm_sample              :string(255)
#

class Mount < ApplicationRecord
  include Collectable
  translates :name, :description, :enhanced_description, :tooltip

  scope :include_related, -> { include_sources }
  scope :ordered, -> { order(patch: :desc, order: :desc) }

  def multi_seated?
    seats > 1
  end
end

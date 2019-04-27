# == Schema Information
#
# Table name: mounts
#
#  id                      :bigint(8)        not null, primary key
#  name_en                 :string(255)      not null
#  name_de                 :string(255)      not null
#  name_fr                 :string(255)      not null
#  name_ja                 :string(255)      not null
#  flying                  :boolean          not null
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
#

class Mount < ApplicationRecord
  translates :name, :description, :enhanced_description, :tooltip
end

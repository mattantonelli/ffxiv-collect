# == Schema Information
#
# Table name: locations
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  region_en  :string(255)      not null
#  region_de  :string(255)      not null
#  region_fr  :string(255)      not null
#  region_ja  :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ApplicationRecord
  has_many :npcs
  has_many :alphabetical_npcs, -> { order("name_#{I18n.locale}") }, class_name: 'NPC'

  translates :name, :region
end

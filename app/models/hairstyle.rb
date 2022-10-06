# == Schema Information
#
# Table name: hairstyles
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
#  patch          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  gender         :string(255)
#  vierable       :boolean          default(FALSE)
#  image_count    :integer          default(0)
#  hrothable      :boolean          default(FALSE)
#

class Hairstyle < ApplicationRecord
  include Collectable
  translates :name, :description

  scope :include_related, -> { include_sources }
  scope :ordered, -> { order(patch: :desc, id: :desc) }
end

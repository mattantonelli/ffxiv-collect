# == Schema Information
#
# Table name: content_types
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#  instance   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ContentType < ApplicationRecord
  translates :name

  scope :instance_types, -> { where(instance: true) }

  def self.instance_type_names
    self.instance_types.pluck(:name_en)
  end

  def self.instance_types_regex
    self.instance_types.pluck(:name_en).join('|')
  end
end

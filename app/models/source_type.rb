# == Schema Information
#
# Table name: source_types
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_de    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_ja    :string(255)      not null
#

class SourceType < ApplicationRecord
  has_many :sources, foreign_key: 'type_id'
  translates :name

  scope :with_filters, -> (filters) do
    excluded = filters[:premium] == 'hide' ? ['Premium'] : []
    excluded += %w(Event Limited) if filters[:limited] == 'hide'
    where.not(name_en: excluded)
  end
end

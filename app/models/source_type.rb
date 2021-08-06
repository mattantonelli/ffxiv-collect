# == Schema Information
#
# Table name: source_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SourceType < ApplicationRecord
  has_many :sources, foreign_key: 'type_id'

  scope :with_filters, -> (filters) do
    excluded = filters[:premium] == 'hide' ? ['Premium'] : []
    excluded += %w(Event Feast Limited) if filters[:limited] == 'hide'
    where.not(name: excluded)
  end
end

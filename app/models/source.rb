# == Schema Information
#
# Table name: sources
#
#  id               :bigint(8)        not null, primary key
#  collectable_id   :integer          not null
#  collectable_type :string(255)      not null
#  text             :string(255)
#  type_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Source < ApplicationRecord
  belongs_to :collectable, polymorphic: true
  belongs_to :type, class_name: 'SourceType'
end

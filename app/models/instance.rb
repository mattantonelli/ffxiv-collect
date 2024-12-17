# == Schema Information
#
# Table name: instances
#
#  id           :bigint(8)        not null, primary key
#  name_en      :string(255)      not null
#  name_de      :string(255)      not null
#  name_fr      :string(255)      not null
#  name_ja      :string(255)      not null
#  content_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Instance < ApplicationRecord
  translates :name

  def self.valid_types
    # TODO: This list should just contain valid content types.
    #       The short-hand source types should be maintained in Source.
    [
      'Dungeon', 'Trial', 'Raid', 'Ultimate Raid', 'Chaotic Raid', 'Chaotic Alliance Raid',
      'Treasure Hunt', 'V&C Dungeon', 'V&C Dungeon Finder'
    ].freeze
  end

  def self.valid_types_regex
    Regexp.new(self.valid_types.join('|'))
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(content_type)
  end
end

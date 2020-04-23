# == Schema Information
#
# Table name: character_items
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  item_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CharacterItem < ApplicationRecord
  belongs_to :character, counter_cache: :items_count
  belongs_to :item
end

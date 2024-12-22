# == Schema Information
#
# Table name: character_outfits
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  outfit_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CharacterOutfit < ApplicationRecord
  belongs_to :character, counter_cache: :outfits_count, touch: true
  belongs_to :outfit
end

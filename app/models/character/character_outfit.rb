# == Schema Information
#
# Table name: character_outfits
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  outfit_id    :integer
#
class CharacterOutfit < ApplicationRecord
  belongs_to :character, counter_cache: :outfits_count, touch: true
  belongs_to :outfit
end

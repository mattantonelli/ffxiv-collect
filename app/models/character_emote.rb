# == Schema Information
#
# Table name: character_emotes
#
#  id           :bigint(8)        not null, primary key
#  character_id :integer
#  emote_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CharacterEmote < ApplicationRecord
  belongs_to :character, counter_cache: :emotes_count
  belongs_to :emote
end

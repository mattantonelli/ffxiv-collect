# == Schema Information
#
# Table name: character_api_tokens
#
#  id              :bigint(8)        not null, primary key
#  character_id    :integer          not null
#  user_id         :integer          not null
#  token_hash      :string(64)       not null
#  last_used_at    :datetime
#  last_user_agent :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CharacterApiToken < ApplicationRecord
  belongs_to :character
  belongs_to :user

  attr_reader :plaintext

  before_create :generate_token

  def self.authenticate(raw_token)
    return nil if raw_token.blank?
    find_by(token_hash: Digest::SHA256.hexdigest(raw_token))
  end

  def touch_usage!(user_agent)
    update_columns(last_used_at: Time.current,
                   last_user_agent: user_agent.to_s.first(255))
  end

  private

  def generate_token
    @plaintext = SecureRandom.urlsafe_base64(32)
    self.token_hash = Digest::SHA256.hexdigest(@plaintext)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  username           :string(255)
#  discriminator      :integer
#  avatar_url         :string(255)
#  provider           :string(255)
#  uid                :string(255)
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  character_id       :integer
#  admin              :boolean          default(FALSE)
#  mod                :boolean          default(FALSE)
#  database           :string(255)      default("garland"), not null
#

class User < ApplicationRecord
  belongs_to :character, required: false
  has_many :user_characters
  has_many :characters, through: :user_characters
  has_many :verified_characters, -> (user) { where(verified_user: user) }, through: :user_characters, source: :character
  has_many :modifications, class_name: 'PaperTrail::Version', foreign_key: :whodunnit

  devise :timeoutable, :trackable, :omniauthable, omniauth_providers: [:discord]

  def triple_triad
    begin
      response = RestClient::Request.execute(url: "https://triad.raelys.com/api/users/#{self.uid}?limit_missing=0",
                                             method: :get, verify_ssl: false)
      JSON.parse(response, symbolize_names: true).merge(status: :ok)
    rescue RestClient::Forbidden
      { status: :private }
    rescue RestClient::NotFound
      { status: :not_found }
    end
  end

  def self.from_omniauth(auth)
    # Clean up any special characters in the username
    username = auth.info.name.encode(Encoding.find('ASCII'), { invalid: :replace, undef: :replace, replace: '' })

    discord_user = User.find_by(provider: auth.provider, uid: auth.uid)
    attributes = { username: username, discriminator: auth.extra.raw_info.discriminator, avatar_url: auth.info.image }

    if discord_user.present?
      discord_user.update!(attributes)
    else
      discord_user = User.create!(attributes.merge(provider: auth.provider, uid: auth.uid))
    end

    discord_user
  end
end

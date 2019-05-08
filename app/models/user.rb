class User < ApplicationRecord
  devise :trackable, :omniauthable, omniauth_providers: [:discord]

  def self.from_omniauth(auth)
    # Clean up any special characters in the username
    username = auth.info.name.encode(Encoding.find('ASCII'), { invalid: :replace, undef: :replace, replace: '' })

    discord_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = username
      user.discriminator = auth.extra.raw_info.discriminator
      user.avatar_url = auth.info.image
    end

    # Keep existing Discord users' data up to date
    if discord_user.persisted?
      discord_user.update(username: username,
                          discriminator: auth.extra.raw_info.discriminator,
                          avatar_url: auth.info.image)
    end

    discord_user
  end
end

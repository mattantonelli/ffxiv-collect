class DiscordController < ApiController
  skip_before_action :set_defaults, :set_language, :verify_authenticity_token

  def interactions
    # Request signature verification
    begin
      verify_request! if Rails.env.production?
    rescue Ed25519::VerifyError
      return head :unauthorized
    end

    body = JSON.parse(request.body.read)

    if body['type'] == 1
      # Respond to Discord PING request
      render json: { type: 1 }
    else
      # Respond to /commands
      type = body['data']['name']

      begin
        if type == 'profile'
          user = body['data']['options'].find { |option| option['name'] == 'user' }['value']
          data = Discord.embed_character(user)
        else
          name = body['data']['options'].find { |option| option['name'] == 'name' }['value']
          data = Discord.embed_collectable(type, name)
        end

        render json: { type: 3, data: data }
      rescue RestClient::ExceptionWithResponse => e
        # Return API error messages when they are provided
        render json: { type: 3, data: { content: JSON.parse(e.response)['error'] } }
      rescue Exception => e
        log_backtrace(e)
        render json: { type: 3, data: { content: 'Sorry, something broke!' } }
      end
    end
  end

  private
  def verify_key
    Ed25519::VerifyKey.new([Rails.application.credentials.dig(:discord, :interactions_public_key)].pack('H*')).freeze
  end

  def verify_request!
    signature = request.headers['X-Signature-Ed25519']
    timestamp = request.headers['X-Signature-Timestamp']
    verify_key.verify([signature].pack('H*'), "#{timestamp}#{request.raw_post}")
  end
end

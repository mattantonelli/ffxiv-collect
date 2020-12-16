class DiscordController < ApiController
  skip_before_action :set_defaults, :set_language, :verify_authenticity_token

  def interactions
    # Request signature verification
    begin
      verify_request!
    rescue Ed25519::VerifyError
      return head :unauthorized
    end

    body = JSON.parse(request.body.read)

    if body['type'] == 1
      # Respond to Discord PING request
      render json: { type: 1 }
    else
      # Respond to /commands
      response = { type: 4, data: { content: 'This is a test' } }
      render json: response
    end
  end

  private
  def verify_request!
    signature = request.headers['X-Signature-Ed25519']
    timestamp = request.headers['X-Signature-Timestamp']
    verify_key.verify([signature].pack('H*'), "#{timestamp}#{request.raw_post}")
  end

  def verify_key
    Ed25519::VerifyKey.new([Rails.application.credentials.dig(:discord, :interactions_public_key)].pack('H*')).freeze
  end
end

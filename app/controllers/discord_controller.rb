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
      type = body['data']['name']
      name = body['data']['options'].find { |option| option['name'] == 'name' }['value']
      url = "https://ffxivcollect.com/api/#{type.pluralize}?name_en_cont=#{name}"
      results = JSON.parse(RestClient.get(url), symbolize_names: true)[:results]
        .sort_by { |collectable| collectable[:name].size }
      collectable = results.first

      embed = Discordrb::Webhooks::Embed.new(color: 0xdaa556)

      if type == 'spell'
        embed.description = collectable[:tooltip].gsub(/(?<=\n)(.*?):/, '**\1:**')
      elsif type == 'title'
        embed.description = collectable.dig(:achievement, :description)
      else
        embed.description = collectable[:enhanced_description] || collectable[:description]
      end

      embed.image = Discordrb::Webhooks::EmbedImage.new(url: collectable[:image])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: collectable[:icon])
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: collectable[:name],
                                                          url: collectable_url(type, collectable[:id]))

      if results.size > 1
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: additional_results(results))
      end

      if type == 'spell'
        embed.add_field(name: 'Type', value: collectable.dig(:type, :name), inline: true)
        embed.add_field(name: 'Aspect', value: collectable.dig(:aspect, :name), inline: true)
      else
        embed.add_field(name: 'Owned', value: collectable[:owned], inline: true)
      end

      embed.add_field(name: 'Patch', value: collectable[:patch], inline: true)

      if collectable[:sources]
        embed.add_field(name: 'Source', value: format_sources(collectable))
      end

      response = { type: 3, data: { embeds: [embed.to_hash] } }
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

  def collectable_url(type, id)
    "https://ffxivcollect.com/#{type.pluralize}/#{id}"
  end

  def format_sources(collectable)
    collectable[:sources].map { |source| source[:text] }.join("\n")
  end

  def additional_results(results)
    names = results[1..10].map { |collectable| collectable[:name] }
    names << '...' if results.size > 11
    "Also available: #{names.join(', ')}"
  end
end

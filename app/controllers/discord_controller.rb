include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

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

      begin
        if type == 'profile'
          user = body['data']['options'].find { |option| option['name'] == 'user' }['value']
          data = embed_character(user)
        else
          name = body['data']['options'].find { |option| option['name'] == 'name' }['value']
          data = embed_collectable(type, name)
        end

        render json: { type: 3, data: data }
      rescue RestClient::ExceptionWithResponse => e
        render json: { type: 3, content: JSON.parse(e.response)['error'] }
      end
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

  def category_title(category)
    case category
    when 'orchestrions' then 'Orchestrion'
    when 'spells' then 'Blue Magic'
    when 'triad' then 'Triple Triad'
    else category.titleize
    end
  end

  def embed_collectable(type, name)
    url = "https://ffxivcollect.com/api/#{type.pluralize}?name_en_cont=#{name}"
    results = JSON.parse(RestClient.get(url), symbolize_names: true)[:results]
      .sort_by { |collectable| collectable[:name].size }
    collectable = results.first

    if collectable.nil?
      return { content: "#{type.titleize} not found." }
    end

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

    { embeds: [embed.to_hash] }
  end

  def embed_character(user)
    url = "https://ffxivcollect.com/api/users/#{user}"
    character = JSON.parse(RestClient.get(url), symbolize_names: true)

    embed = Discordrb::Webhooks::Embed.new(color: 0xdaa556)

    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: character[:avatar])
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{character[:name]} (#{character[:server]})",
                                                        url: "https://ffxivcollect.com/characters/#{character[:id]}")
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Last updated #{time_ago_in_words(character[:last_parsed])} ago.")

    if character[:achievements][:public]
      count, total, points, points_total =
        character[:achievements].values_at(:count, :total, :points, :points_total).map { |value| number_with_delimiter(value) }

      embed.add_field(name: 'Achievements', inline: true,
                      value: "#{count} of #{total} complete\n#{points} of #{points_total} points")
    else
      embed.add_field(name: 'Achievements', inline: true, value: 'Set to private.')
    end

    %i(mounts minions orchestrions emotes bardings hairstyles armoires spells triad).each do |category|
      next unless character[category].present? && character[category][:count] > 0

      count, total = character[category].values_at(:count, :total)
      value = "#{count}/#{total} (#{((count / total.to_f) * 100).to_i}%)"
      embed.add_field(name: category_title(category.to_s), value: value, inline: true)
    end

    { embeds: [embed.to_hash] }
  end
end

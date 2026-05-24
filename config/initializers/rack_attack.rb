class Rack::Attack
  ### Throttle the plugin write API per bearer token ###
  throttle('api_owned_writes/token', limit: 60, period: 1.minute) do |req|
    if req.post? && req.path =~ %r{\A/api/characters/\d+/[^/]+/owned\z}
      token = req.env['HTTP_AUTHORIZATION'].to_s[/\ABearer\s+(.+)\z/, 1]
      Digest::SHA256.hexdigest(token) if token.present?
    end
  end

  throttle('api_owned_writes/token/day', limit: 5_000, period: 1.day) do |req|
    if req.post? && req.path =~ %r{\A/api/characters/\d+/[^/]+/owned\z}
      token = req.env['HTTP_AUTHORIZATION'].to_s[/\ABearer\s+(.+)\z/, 1]
      Digest::SHA256.hexdigest(token) if token.present?
    end
  end

  ### Throttle token generation per IP (anti-bruteforce of the web UI) ###
  throttle('api_token_generation/ip', limit: 10, period: 1.hour) do |req|
    req.ip if req.post? && req.path =~ %r{\A/character/\d+/api_token\z}
  end

  self.throttled_responder = lambda do |request|
    retry_after = (request.env['rack.attack.match_data'] || {})[:period]
    [429,
     { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s },
     [{ status: 429, error: 'Too many requests' }.to_json]]
  end
end

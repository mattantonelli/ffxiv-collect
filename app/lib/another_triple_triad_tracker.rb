module AnotherTripleTriadTracker
  extend self

  ROOT_URL = 'https://triad.raelys.com'.freeze

  def user(uid)
    url = "#{ROOT_URL}/api/users/#{uid}"
    response = RestClient::Request.execute(url: url, method: :get, verify_ssl: false)
    results = JSON.parse(response, symbolize_names: true)

    {
      cards_count: "#{results[:cards][:owned]} / #{results[:cards][:total]}",
      card_ids: results[:cards][:ids],
      npc_count: "#{results[:npcs][:defeated]} / #{results[:npcs][:total]}",
      npc_ids: results[:npcs][:ids]
    }
  end
end

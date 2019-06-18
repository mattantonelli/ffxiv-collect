module LeaderboardsHelper
  def categories
    ['Achievements', 'Achievement Points', 'Mounts', 'Minions', 'Orchestrion', 'Emotes',
     'Bardings', 'Hairstyles', 'Armoire'].freeze
  end

  def data_center(server)
    Character.servers_by_data_center.each { |dc, servers| return dc if servers.include?(server) }
  end

  def grouped_servers(server)
    servers = Character.servers_by_data_center.flat_map do |dc, servers|
      servers.map do |server|
        [server, server, { class: dc.downcase }]
      end
    end

    options_for_select(servers.sort, server)
  end
end

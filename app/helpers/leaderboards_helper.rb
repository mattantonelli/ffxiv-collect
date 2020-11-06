module LeaderboardsHelper
  def categories
    [[t('general.achievement.other'), 'Achievements'], ["#{t('general.achievement.one')} #{t('general.points')}", 'Achievement Points'],
     [t('general.mount.other'), 'Mounts'], [t('general.minion.other'), 'Minions'], [t('general.orchestrion'), 'Orchestrion'],
     [t('general.emote', count: 2), 'Emotes'], [t('general.barding',count: 2), 'Bardings'], [t('general.hairstyle', count: 2), 'Hairstyles'],
     [t('general.armoire.one'),'Armoire']].freeze
  end

  def data_center(server)
    Character.servers_by_data_center.each { |dc, servers| return dc if servers.include?(server) }
    'Unknown'
  end

  def grouped_servers(server)
    servers = Character.servers_by_data_center.flat_map do |dc, servers|
      servers.map do |server|
        [server, server, { class: dc.downcase }]
      end
    end

    options_for_select(servers.sort, server)
  end

  def limit_options(limit)
    options = [10, 100, 1000].map do |option|
      ["Top #{option}", option]
    end

    options_for_select(options, limit)
  end
end

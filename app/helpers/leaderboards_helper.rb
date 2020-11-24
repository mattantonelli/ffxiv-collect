module LeaderboardsHelper
  def leaderboards_categories(selected = nil)
    options_for_select([[t('achievements.title'), 'achievements'],
                        [t('achievement_points.title'), 'achievement_points'],
                        [t('mounts.title'), 'mounts'], [t('minions.title'), 'minions'],
                        [t('orchestrions.title'), 'orchestrions'], [t('emotes.title'), 'emotes'],
                        [t('bardings.title'), 'bardings'], [t('hairstyles.title'), 'hairstyles'],
                        [t('armoires.title'), 'armoires']], selected).freeze
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
      ["#{t('leaderboards.top')} #{option}", option]
    end

    options_for_select(options, limit)
  end
end

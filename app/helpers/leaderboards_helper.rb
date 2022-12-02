module LeaderboardsHelper
  def leaderboards_categories(selected = nil)
    options_for_select([[t('achievements.title'), 'achievement_points'],
                        [t('ranked_achievements.title'), 'ranked_achievement_points'],
                        [t('mounts.title'), 'mounts'], [t('ranked_mounts.title'), 'ranked_mounts'],
                        [t('minions.title'), 'minions'], [t('ranked_minions.title'), 'ranked_minions'],
                        [t('orchestrions.title'), 'orchestrions'], [t('emotes.title'), 'emotes'],
                        [t('bardings.title'), 'bardings'], [t('hairstyles.title'), 'hairstyles'],
                        [t('armoires.title'), 'armoires'],
                        [t('fashions.title'), 'fashions'],
                        [t('records.title'), 'records'],
                        [t('survey_records.title'), 'survey_records']], selected).freeze
  end

  def limit_options(limit)
    options = [10, 100, 1000].map do |option|
      ["#{t('leaderboards.top')} #{option}", option]
    end

    options_for_select(options, limit)
  end
end

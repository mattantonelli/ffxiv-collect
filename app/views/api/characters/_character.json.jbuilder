json.(character, :id, :name, :server, :data_center, :portrait, :avatar, :last_parsed)
json.verified character.verified?

json.achievements do
  json.count character.achievements_count == -1 ? 0 : character.achievements_count
  json.total Achievement.count
  json.points character.achievement_points
  json.points_total Achievement.sum(:points)
  json.ranked_points character.ranked_achievement_points
  json.ranked_points_total Achievement.exclude_time_limited.sum(:points)
  json.ranked_time character.last_ranked_achievement_time
  json.public character.achievements_count != -1
  json.ids character.achievement_ids if params[:ids].present?
end

%w(mount minion orchestrion spell emote barding hairstyle armoire fashion record survey_record).each do |collectable|
  json.set! collectable.pluralize do
    json.count character.send("#{collectable}s_count")
    json.total collectable == 'minion' ? Minion.summonable.count : collectable.capitalize.constantize.count

    if collectable.match?(/mount|minion/)
      json.ranked_count character.send("ranked_#{collectable}s_count")

      if collectable == 'minion'
        json.ranked_total Minion.ranked.summonable.count
      else
        json.ranked_total collectable.capitalize.constantize.ranked.count
      end
    end

    json.ids character.send("#{collectable}_ids") if params[:ids].present?
  end
end

json.rankings character.rankings
json.relics character_relics(character)

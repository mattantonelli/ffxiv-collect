#!/usr/bin/env bash
# Periodically prints DB row counts + a rough ETA while the updater's rake
# tasks run. Started in the background by updater.sh and killed on exit.
# Writes to stderr so output is unbuffered through `docker logs`.
#
# ETA is computed from "tables with rows > 0 / total tables * elapsed" — a
# linear extrapolation. It's coarse (tables vary wildly in load time) but
# gives a useful order-of-magnitude estimate.

INTERVAL="${PROGRESS_INTERVAL:-30}"

TABLES="items achievements titles mounts minions orchestrions emotes bardings hairstyles armoires outfits spells fashions facewear records survey_records occult_records frames cards npcs tomestone_rewards quests instances"
TOTAL_TABLES=$(echo "$TABLES" | wc -w)

mysql_q() {
  mysql \
    -h "${DATABASE_HOST}" \
    -P "${DATABASE_PORT:-3306}" \
    -u "${DATABASE_USERNAME}" \
    -p"${DATABASE_PASSWORD}" \
    -N -B "${DATABASE_NAME}" \
    -e "$1" 2>/dev/null
}

START_TIME=$(date +%s)
PREV_TOTAL=0

while sleep "$INTERVAL"; do
  parts=""
  for t in $TABLES; do
    parts+="SELECT '${t}' tbl, (SELECT COUNT(*) FROM \`${t}\`) n UNION ALL "
  done
  query="${parts%UNION ALL }"
  result=$(mysql_q "$query")
  [ -z "$result" ] && continue

  done_count=$(echo "$result" | awk '$2 > 0' | wc -l)
  total_rows=$(echo "$result" | awk '{ s+=$2 } END { print s+0 }')
  elapsed=$(($(date +%s) - START_TIME))

  if [ "$done_count" -gt 0 ] && [ "$done_count" -lt "$TOTAL_TABLES" ]; then
    eta_sec=$((elapsed * (TOTAL_TABLES - done_count) / done_count))
    eta_str="$((eta_sec / 60))m"
  elif [ "$done_count" -ge "$TOTAL_TABLES" ]; then
    eta_str="<1m"
  else
    eta_str="--"
  fi

  delta=$((total_rows - PREV_TOTAL))
  PREV_TOTAL=$total_rows

  {
    printf "\n[progress %s | elapsed %dm%02ds | %d/%d tables | %d rows (+%d) | ETA ~%s]\n" \
      "$(date +%H:%M:%S)" \
      $((elapsed / 60)) $((elapsed % 60)) \
      "$done_count" "$TOTAL_TABLES" \
      "$total_rows" "$delta" \
      "$eta_str"
    echo "$result" | awk 'BEGIN{c=0} { printf "  %-18s %7s", $1, $2; c++; if (c%3==0) printf "\n"; else printf "  " } END { if (c%3) printf "\n" }'
    echo ""
  } >&2
done

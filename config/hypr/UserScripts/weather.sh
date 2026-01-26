#!/bin/bash
set -u

city="BOLOGNA"
cachedir="$HOME/.cache/rbn"
cachefile="$cachedir/weather"

mkdir -p "$cachedir"

if [ ! -s "$cachefile" ] || [ $(( $(date +%s) - $(stat -c '%Y' "$cachefile") )) -gt 1740 ]; then
  curl -s "https://en.wttr.in/$city?0qnT" >"$cachefile"
fi

mapfile -t lines <"$cachefile"

# Fallback di sicurezza
[ "${#lines[@]}" -lt 3 ] && printf '{"text":"","tooltip":"Weather unavailable"}\n' && exit 0

location="${lines[0]}"
condition_raw="${lines[1]##*,}"
temperature=$(echo "${lines[2]}" | sed -E 's/([0-9]+)\.\./\1–/g')

cond=$(echo "$condition_raw" | tr '[:upper:]' '[:lower:]')

case "$cond" in
  *clear*|*sun*) icon="" ;;
  *cloud*) icon="" ;;
  *fog*|*mist*) icon="" ;;
  *rain*) icon="󰼳" ;;
  *snow*) icon="󰙿" ;;
  *thunder*) icon="" ;;
  *) icon="" ;;
esac

printf '{"text":"%s %s","alt":"%s","tooltip":"%s: %s %s"}\n' \
  "$temperature" "$icon" "$city" "$city" "$temperature" "$condition_raw"


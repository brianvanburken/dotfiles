#!/bin/bash

IFS=$'\x1f' read -r model ctx_tokens ctx_max five_pct five_reset seven_pct seven_reset <<< "$(
  cat | jq -r '
    [
      (.model.display_name // "unknown"),
      (.context_window.total_input_tokens // ""),
      (.context_window.context_window_size // ""),
      (.rate_limits.five_hour.used_percentage // ""),
      (if .rate_limits.five_hour.resets_at != null then
        (.rate_limits.five_hour.resets_at | strflocaltime("%H:%M"))
      else "" end),
      (.rate_limits.seven_day.used_percentage // ""),
      (if .rate_limits.seven_day.resets_at != null then
        (.rate_limits.seven_day.resets_at | strflocaltime("%d-%m %H:%M"))
      else "" end)
    ] | join("")
  '
)"

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

pct_color() {
  if [[ "$1" -lt 80 ]]; then
    echo "$GREEN"
  elif [[ "$1" -lt 90 ]]; then
    echo "$YELLOW"
  else
    echo "$RED"
  fi
}

segments=("$model")

if [[ -n "$ctx_tokens" && -n "$ctx_max" && "$ctx_max" -gt 0 ]]; then
  ctx_pct=$(( (ctx_tokens * 100 + ctx_max / 2) / ctx_max ))
  ctx_k=$(( (ctx_tokens + 500) / 1000 ))

  if [[ "$ctx_tokens" -lt 80000 ]]; then
    color="$GREEN"
  elif [[ "$ctx_tokens" -lt 100000 ]]; then
    color="$YELLOW"
  else
    color="$RED"
  fi

  segments+=("ctx:${color}${ctx_k}k${RESET} ${DIM}(${ctx_pct}%)${RESET}")
fi

if [[ -n "$five_pct" ]]; then
  rounded=$(printf '%.0f' "$five_pct")
  reset_suffix=""
  [[ -n "$five_reset" ]] && reset_suffix=" ${DIM}(${five_reset})${RESET}"
  segments+=("s:$(pct_color "$rounded")${rounded}%${RESET}${reset_suffix}")
fi

if [[ -n "$seven_pct" ]]; then
  rounded=$(printf '%.0f' "$seven_pct")
  reset_suffix=""
  [[ -n "$seven_reset" ]] && reset_suffix=" ${DIM}(${seven_reset})${RESET}"
  segments+=("w:$(pct_color "$rounded")${rounded}%${RESET}${reset_suffix}")
fi

output="${segments[0]}"
for segment in "${segments[@]:1}"; do
  output="$output | $segment"
done

echo -e "$output"

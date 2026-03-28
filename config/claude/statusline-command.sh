#!/bin/sh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

out="$model"

if [ -n "$five_pct" ]; then
  five_pct_fmt=$(printf "%.0f" "$five_pct")
  if [ -n "$five_resets" ]; then
    five_resets_fmt=$(date -r "$five_resets" "+%H:%M" 2>/dev/null || date -d "@$five_resets" "+%H:%M" 2>/dev/null)
    out="$out | s:${five_pct_fmt}%(${five_resets_fmt})"
  else
    out="$out | s:${five_pct_fmt}%"
  fi
fi

if [ -n "$week_pct" ]; then
  week_pct_fmt=$(printf "%.0f" "$week_pct")
  if [ -n "$week_resets" ]; then
    week_resets_fmt=$(date -r "$week_resets" "+%d-%m %H:%M" 2>/dev/null || date -d "@$week_resets" "+%d-%m %H:%M" 2>/dev/null)
    out="$out | w:${week_pct_fmt}%(${week_resets_fmt})"
  else
    out="$out | w:${week_pct_fmt}%"
  fi
fi

echo "$out"

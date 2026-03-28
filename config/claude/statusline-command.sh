#!/bin/sh
echo "$(cat)" | jq -r '
  def fmt_rate(prefix; pct; resets; datefmt):
    if pct != null then
      "| \(prefix):\(pct | round | tostring)%" +
      if resets != null then "(\(resets | strflocaltime(datefmt)))" else "" end
    else "" end;

  [
    (.model.display_name // "unknown"),
    (if .context_window.used_percentage != null then
      "| ctx:\(.context_window.used_percentage | round | tostring)%"
    else "" end),
    fmt_rate("s"; .rate_limits.five_hour.used_percentage; .rate_limits.five_hour.resets_at; "%H:%M"),
    fmt_rate("w"; .rate_limits.seven_day.used_percentage; .rate_limits.seven_day.resets_at; "%d-%m %H:%M")
  ] | map(select(. != "")) | join(" ")
'

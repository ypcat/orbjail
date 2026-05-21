#!/usr/bin/env bash
input=$(cat)
jq=/home/peilun/.local/share/mise/installs/jaq/latest/jaq

model_full=$(echo "$input" | $jq -r '.model.display_name // empty')
used=$(echo "$input" | $jq -r '.context_window.used_percentage // empty')
five_pct=$(echo "$input" | $jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | $jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | $jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | $jq -r '.rate_limits.seven_day.resets_at // empty')

# Shorten model name: strip leading "Claude ", keep e.g. "3.5 Sonnet", "3.7 Sonnet"
short_model=""
if [ -n "$model_full" ]; then
  short_model=$(echo "$model_full" | sed 's/^Claude //' | sed 's/ 20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]$//')
fi

# Color a percentage 0-100 green->yellow->red
pct_color() {
  local pct_int
  pct_int=$(printf '%.0f' "$1")
  if [ "$pct_int" -le 40 ]; then
    printf '\033[32m'
  elif [ "$pct_int" -le 70 ]; then
    printf '\033[33m'
  else
    printf '\033[31m'
  fi
}

# Format seconds-until-reset as -X.Xd / -X.Xh / -X.Xm (coarsest unit, 1 decimal)
fmt_countdown() {
  local reset_epoch="$1"
  local now
  now=$(date +%s)
  local secs=$(( reset_epoch - now ))
  if [ "$secs" -le 0 ]; then
    echo "now"
    return
  fi
  if [ "$secs" -ge 86400 ]; then
    awk "BEGIN {printf \"-%.1fd\", $secs / 86400}"
  elif [ "$secs" -ge 3600 ]; then
    awk "BEGIN {printf \"-%.1fh\", $secs / 3600}"
  else
    awk "BEGIN {printf \"-%.1fm\", $secs / 60}"
  fi
}

parts=""

# Model (magenta)
if [ -n "$short_model" ]; then
  parts=$(printf '\033[35m%s\033[0m' "$short_model")
fi

# Context used % (color coded green->red)
if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  color=$(pct_color "$used_int")
  parts="$parts $(printf "${color}ctx:%d%%\033[0m" "$used_int")"
fi

# 5h rate limit
if [ -n "$five_pct" ]; then
  five_int=$(printf '%.0f' "$five_pct")
  color=$(pct_color "$five_int")
  limit_str=$(printf "${color}5h:%d%%\033[0m" "$five_int")
  if [ -n "$five_reset" ]; then
    countdown=$(fmt_countdown "$five_reset")
    limit_str="$limit_str$(printf '\033[2m(%s)\033[0m' "$countdown")"
  fi
  parts="$parts $limit_str"
fi

# 7d rate limit
if [ -n "$week_pct" ]; then
  week_int=$(printf '%.0f' "$week_pct")
  color=$(pct_color "$week_int")
  limit_str=$(printf "${color}7d:%d%%\033[0m" "$week_int")
  if [ -n "$week_reset" ]; then
    countdown=$(fmt_countdown "$week_reset")
    limit_str="$limit_str$(printf '\033[2m(%s)\033[0m' "$countdown")"
  fi
  parts="$parts $limit_str"
fi

printf '%s' "$parts"

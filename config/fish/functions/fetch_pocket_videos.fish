function fetch_pocket_videos -d "Download videos from Pocket" --argument user
  curl "https://pocket-rss.com/feed/$user/json" \
    | jq '.items.[].url' --raw-output \
    | rg 'https://(youtube.com|youtu.be|yewtu.be|vimeo.com|twitch.tv)' \
    | xargs yt-dlp
end

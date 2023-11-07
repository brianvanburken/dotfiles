function fetch_pocket_videos -d "Download videos from Pocket" --argument user
  curl "https://getpocket.com/users/$user/feed/unread" \
    | xq -q 'rss channel item guid' \
    | rg 'https://(youtube.com|youtu.be|yewtu.be|vimeo.com)' \
    | xargs yt-dlp
end

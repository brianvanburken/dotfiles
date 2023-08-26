function fetch_pocket_videos -d "Download videos from Pocket" --argument user
  curl "https://getpocket.com/users/$user/feed/unread" \
    | rg '<link>(?:.*(?:yewtu.be|youtu(?:.be|be.com))(.*))</link>' -r 'https://youtube.com$1' \
    | xargs -I{} yt-dlp {}
end

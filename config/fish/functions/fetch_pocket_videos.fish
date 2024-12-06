function fetch_pocket_videos -d "Download videos from Pocket" --argument user
    set pocket_backup_file $XDG_CACHE_HOME/fetch_pocket/pocket_items.json
    # Determine cache directory using XDG_CACHE_HOME
    set cache_dir $XDG_CACHE_HOME/fetch_pocket_videos
    mkdir -p $cache_dir

    # Define file paths
    set urls_current $cache_dir/urls_current.txt
    set urls_previous $cache_dir/urls_previous.txt

    # Extract URLs and filter for video sites, then sort uniquely
    jq 'values[].given_url' --raw-output $pocket_backup_file \
        | rg '(youtube.com|youtu\.be|yewtu\.be|vimeo\.com|twitch\.tv)' \
        | sort -u > $urls_current

    # Ensure the previous URLs file exists
    if not test -e $urls_previous
        touch $urls_previous
    end

    # Find new URLs by comparing current and previous lists
    set new_urls (comm -23 $urls_current $urls_previous)

    # Download new URLs using yt-dlp
    if test (count $new_urls) -gt 0
        echo "Downloading new videos..."
        echo $new_urls | xargs yt-dlp
    else
        echo "No new videos to download."
    end

    # Update the previous URLs file
    cp $urls_current $urls_previous
end

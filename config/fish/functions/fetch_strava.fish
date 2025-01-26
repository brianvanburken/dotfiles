function fetch_strava -d "Download Strava to CSV file" --argument user
  strava-offline sqlite --verbose \
    && sqlite3 ~/library/Application\ Support/strava_offline/strava.sqlite -header -csv \
      "SELECT start_date, distance, total_elevation_gain FROM activity WHERE type = 'Run' OR type = 'TrailRun';" \
      > strava.csv
end

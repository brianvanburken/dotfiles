function fetch_pocket
    # 1) Check consumer key
    if test -z "$POCKET_CONSUMER_KEY"
        echo "Please set your Pocket consumer key in \$POCKET_CONSUMER_KEY."
        return 1
    end

    # 2) Prepare cache paths
    if test -n "$XDG_CACHE_HOME"
        set cache_dir "$XDG_CACHE_HOME/fetch_pocket"
    else
        set cache_dir "$HOME/.cache/fetch_pocket"
    end

    if not test -d "$cache_dir"
        mkdir -p "$cache_dir"
    end

    set access_token_file "$cache_dir/pocket_access_token"
    set output_file       "$cache_dir/pocket_items.json"

    # 3) If we already have an access token, load it
    if test -s "$access_token_file"
        set access_token (cat "$access_token_file")
    else
        #
        # --- OAUTH FLOW (Steps 1–3) ---
        #
        # Step 1: Request token
        set payload (jq -n --arg key "$POCKET_CONSUMER_KEY" --arg uri "about:blank" \
            '{consumer_key: $key, redirect_uri: $uri}')
        set response (echo $payload | curl -s -X POST "https://getpocket.com/v3/oauth/request" \
            -H "Content-Type: application/json; charset=UTF-8" \
            -H "X-Accept: application/json" \
            -d @-)

        # Parse JSON response. Should look like: {"code":"<REQUEST_TOKEN>"}
        set request_token (echo $response | jq -r '.code?')
        if test -z "$request_token" -o "$request_token" = "null"
            echo "Failed to obtain request token. Response was:"
            echo $response
            return 1
        end

        # Step 2: Prompt user to authorize
        set auth_url "https://getpocket.com/auth/authorize?request_token=$request_token&redirect_uri=about:blank"
        echo "Please authorize Pocket access at:"
        echo "$auth_url"
        echo
        echo "Press Enter after authorizing in the browser."
        read

        # Step 3: Exchange request token for access token
        set payload (jq -n --arg key "$POCKET_CONSUMER_KEY" --arg code "$request_token" \
            '{consumer_key: $key, code: $code}')
        set response (echo $payload | curl -s -X POST "https://getpocket.com/v3/oauth/authorize" \
            -H "Content-Type: application/json; charset=UTF-8" \
            -H "X-Accept: application/json" \
            -d @-)

        # The response should be JSON: {"access_token":"...","username":"..."}
        set access_token  (echo $response | jq -r '.access_token?')
        set pocket_user   (echo $response | jq -r '.username?')

        if test -z "$access_token" -o "$access_token" = "null"
            echo "Failed to obtain access token. Response:"
            echo $response
            return 1
        end

        echo "Access token for user $pocket_user obtained."
        echo $access_token > "$access_token_file"
    end

    # 4) Check jq
    if not command -v jq >/dev/null
        echo "Error: 'jq' is required but not installed."
        return 1
    end

    # 5) Load existing items if any
    set existing_items  '{}'
    set existing_ids    ''
    if test -f "$output_file"
        echo "Loading existing items from $output_file..."
        set existing_items (cat "$output_file")
        set existing_ids   (echo $existing_items | jq -r 'keys[]')
    end

    # 6) Fetch new items
    set count 30
    set offset 0
    set new_items '{}'
    set stop_fetching false

    echo "Fetching new items from Pocket..."

    while not $stop_fetching
        echo "Requesting items offset=$offset..."

        set payload (jq -n --arg key "$POCKET_CONSUMER_KEY" --arg token "$access_token" \
            --argjson c $count --argjson o $offset \
            '{consumer_key: $key, access_token: $token, state: "all", detailType: "complete", count: $c, offset: $o, sort: "newest"}')

        set response (echo $payload | curl -s -X POST "https://getpocket.com/v3/get" \
            -H "Content-Type: application/json; charset=UTF-8" \
            -H "X-Accept: application/json" \
            -d @-)

        # Check status
        set status_code (echo $response | jq -r '.status?')
        if test -z "$status_code" -o "$status_code" = "null" -o "$status_code" != "1"
            echo "Error retrieving items. Response:"
            echo $response
            return 1
        end

        # Extract list
        set list (echo $response | jq '.list')
        set num_items (echo $list | jq 'length')
        if test $num_items -eq 0
            echo "No more items to fetch."
            break
        end

        set item_ids (echo $list | jq -r 'keys[]')
        for id in $item_ids
            if contains $id $existing_ids
                echo "Item $id already cached; stopping further fetch."
                set stop_fetching true
            else
                set item_json (echo $list | jq --arg id "$id" '.[$id]')
                set new_items (echo $new_items | jq --argjson it "$item_json" --arg id "$id" '. + {($id): $it}')
            end
        end

        set offset (math $offset + $count)
        sleep 0.5
    end

    # 7) Merge new + existing
    set merged (echo $new_items $existing_items | jq -s '.[0] + .[1]')
    echo $merged | jq '.' > "$output_file"

    echo "Fetched items merged into: $output_file"
end

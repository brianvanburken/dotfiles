function fetch_pocket
    # Check if POCKET_CONSUMER_KEY is set
    if test -z "$POCKET_CONSUMER_KEY"
        echo "Please set your Pocket consumer key in the POCKET_CONSUMER_KEY environment variable."
        return 1
    end

    # Determine the cache directory based on XDG specification, adding 'fetch_pocket' subdirectory
    if test -n "$XDG_CACHE_HOME"
        set cache_dir "$XDG_CACHE_HOME/fetch_pocket"
    else
        set cache_dir "$HOME/.cache/fetch_pocket"
    end

    # Create the cache directory if it doesn't exist
    if not test -d "$cache_dir"
        mkdir -p "$cache_dir"
    end

    # Define the path to store the access token and output file
    set access_token_file "$cache_dir/pocket_access_token"
    set output_file "$cache_dir/pocket_items.json"

    # Step 1: Obtain a request token
    set response (curl -s -X POST "https://getpocket.com/v3/oauth/request" \
        -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
        -d "consumer_key=$POCKET_CONSUMER_KEY&redirect_uri=https://getpocket.com")

    # Extract the request token from the response
    set request_token (string replace 'code=' '' -- $response)

    if test -z "$request_token"
        echo "Failed to obtain request token. Response was: $response"
        return 1
    end

    # Step 2: Direct the user to authorize the app
    set auth_url "https://getpocket.com/auth/authorize?request_token=$request_token&redirect_uri=https://getpocket.com"
    echo "Please visit the following URL to authorize the application:"
    echo $auth_url

    echo
    echo "Press Enter after you have authorized the application."
    read

    # Step 3: Obtain the access token
    set response (curl -s -X POST "https://getpocket.com/v3/oauth/authorize" \
        -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
        -d "consumer_key=$POCKET_CONSUMER_KEY&code=$request_token")

    # Extract the access token and username
    set access_token (echo $response | string match -r 'access_token=([^&]+)' | string replace -r 'access_token=' '')
    set username (echo $response | string match -r 'username=([^&]+)' | string replace -r 'username=' '')

    if test -z "$access_token"
        echo "Failed to obtain access token. Response was: $response"
        return 1
    end

    echo "Successfully obtained access token for user $username"

    # Check if jq is installed
    if not command -v jq >/dev/null
        echo "Error: 'jq' is required but not installed. Please install jq to proceed."
        return 1
    end

    # Load existing items from the output file, if it exists
    if test -f "$output_file"
        echo "Loading existing items from $output_file..."
        set existing_items (cat "$output_file")
        set existing_item_ids (echo $existing_items | jq -r 'keys[]')
    else
        set existing_items '{}'
        set existing_item_ids
    end

    # Step 4: Retrieve new items, stopping when we find an item we already have
    set count 30
    set offset 0
    set new_items '{}'  # Initialize empty JSON object
    set stop_fetching false

    echo "Fetching new items from Pocket..."

    while not $stop_fetching
        # Display progress message
        echo "Fetching items starting from offset $offset..."

        set response (curl -s -X POST "https://getpocket.com/v3/get" \
            -H "Content-Type: application/json; charset=UTF-8" \
            -d '{
                "consumer_key": "'$POCKET_CONSUMER_KEY'",
                "access_token": "'$access_token'",
                "state": "all",
                "detailType": "complete",
                "count": '$count',
                "offset": '$offset',
                "sort": "newest"
            }')

        # Check for errors
        set api_status (echo $response | jq -r '.status')

        # Debug: Print the response if api_status is null or empty
        if test -z "$api_status"
            echo "Warning: 'status' field is missing in the response."
            echo "Response was: $response"
            return 1
        end

        if test "$api_status" != "1"
            echo "Error fetching items. API status: $api_status"
            echo "Response was: $response"
            return 1
        end

        # Get the list of items
        set list (echo $response | jq '.list')

        # Check if the list is empty
        set num_items (echo $list | jq 'length')
        if test $num_items -eq 0
            # No more items to fetch
            echo "No more items to fetch."
            break
        end

        # Process each item
        set item_ids (echo $list | jq -r 'keys[]')
        for id in $item_ids
            if contains $id $existing_item_ids
                # Found an existing item; set flag to stop fetching after current batch
                echo "Item with ID $id already exists. Will not fetch further batches."
                set stop_fetching true
            else
                # Add the new item to new_items
                set item_json (echo $list | jq --arg id "$id" '.[$id]')
                set new_items (echo $new_items | jq --argjson item "$item_json" --arg id "$id" '. + {($id): $item}')
            end
        end

        # Update offset
        set offset (math $offset + $count)

        # Add a 500ms delay to prevent hitting API rate limits
        sleep 0.5
    end

    # Merge new_items with existing_items
    set all_items (echo $new_items $existing_items | jq -s '.[0] + .[1]')

    # Write all items to the output file
    echo $all_items | jq '.' > "$output_file"

    echo "New items have been fetched and merged into $output_file"
end

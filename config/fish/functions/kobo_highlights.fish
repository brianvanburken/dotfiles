function kobo_highlights
    # Path to the Kobo SQLite database
    set db_path '/Volumes/KOBOeReader/.kobo/KoboReader.sqlite'

    # Check if output_dir argument is provided
    if test (count $argv) -lt 1
        echo "Error: You must provide an output directory as the first argument."
        return 1
    end

    # Use the provided argument as the output directory
    set output_dir $argv[1]

    # Debug: Output the provided output directory
    echo "Output directory set to: $output_dir"

    # Create output directory if it doesn't exist
    if not test -d $output_dir
        echo "Creating output directory: $output_dir"
        mkdir -p $output_dir
    end

    # Query to get books with highlights
    set books_query "
        SELECT DISTINCT content.ContentId,
                        content.Title,
                        content.Attribution AS Author,
                        content.DateLastRead,
                        content.TimeSpentReading
        FROM Bookmark
        INNER JOIN content ON Bookmark.VolumeID = content.ContentID
        ORDER BY content.Title;
    "

    # Fetch books with highlights
    echo "Fetching books from database..."
    set books (sqlite3 $db_path "$books_query")

    # Debug: Output the number of books found
    echo "Number of books found: (count $books)"

    # Iterate over each book
    for book in $books
        echo "Processing book: $book"

        # Split book details into fields
        set content_id (echo $book | cut -d'|' -f1)
        set title (echo $book | cut -d'|' -f2)
        set author (echo $book | cut -d'|' -f3)

        # Debug: Output book details
        echo "Content ID: $content_id"
        echo "Title: $title"
        echo "Author(s): $author"

        # Sanitize title for filename
        set filename (echo $title | sed 's/[\/\\ ]/_/g' | tr '[:upper:]' '[:lower:]')
        set filepath "$output_dir/$filename.md"

        # Debug: Output the filepath being written
        echo "Writing to file: $filepath"

        # Write book metadata to text file with \r\n newlines
        printf "Title: %s\r\nAuthor(s): %s\r\n" "$title" "$author" > $filepath

        # Query to get highlights for the book
        set highlights_query "
            SELECT Bookmark.Text FROM Bookmark
            INNER JOIN content ON Bookmark.VolumeID = content.ContentID
            WHERE content.ContentID = '$content_id';
        "

        # Fetch highlights
        echo "Fetching highlights for book: $title"
        set highlights (sqlite3 $db_path "$highlights_query")

        # Debug: Output the number of highlights found
        echo "Number of highlights found for '$title': (count $highlights)"

        # Append highlights to the text file, ensuring \r\n newlines and separation
        for highlight in $highlights
            # Trim leading and trailing spaces
            set trimmed_highlight (string trim $highlight)

            # Append sanitized highlight with blank lines and horizontal rule
            printf "\r\n> %s\r\n\r\n---\r\n\r\n" "$trimmed_highlight" >> $filepath
        end
    end

    # Debug: Indicate completion
    echo "Processing completed. All files are saved in: $output_dir"
end

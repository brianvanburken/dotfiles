function optimise_image
    set input_file $argv[1]

    if not test -f "$input_file"
        echo "Error: File '$input_file' not found."
        return 1
    end

    mogrify -sampling-factor 4:2:0 +profile '!icc,*' -quality 80 -interlace JPEG -format jpg -colorspace sRGB "$input_file"
end

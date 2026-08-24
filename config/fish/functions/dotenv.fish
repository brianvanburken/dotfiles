function dotenv -d "Load environment variables from a .env file"
    set -q argv[1]; or set argv .env
    set -l env_file $argv[1]

    if not test -f "$env_file"
        echo "dotenv: file not found: $env_file" >&2
        return 1
    end

    string trim <"$env_file" |
        string replace 'export ' '' |
        string match -v '#*' |
        string match '*=*' |
        while read -l line
            set -l pair (string split -m 1 = -- "$line")
            set -l key $pair[1]
            set -l value (string trim -c " '\"" -- "$pair[2]")
            set -gx "$key" "$value"
        end

    return 0
end

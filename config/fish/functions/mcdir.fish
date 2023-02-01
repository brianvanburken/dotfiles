function mcdir
  if test -d "$1"
    cd "$1";
  else
    mkdir -p "$1" && cd "$1";
  end
end

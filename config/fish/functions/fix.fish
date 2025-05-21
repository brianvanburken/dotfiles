function fix --description "Load git conflict files into editor"
  git diff --name-only | uniq | xargs -o $EDITOR
end

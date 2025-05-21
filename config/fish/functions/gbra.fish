function gbra --description "Remove all git branches"
  git branch | rg -v "master|main|^\*" | xargs git branch -D
end

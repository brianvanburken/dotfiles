function gbr --description "Remove all merged git branches"
  git branch --merged | rg -v "master|main|^\*" | xargs git branch -D
end

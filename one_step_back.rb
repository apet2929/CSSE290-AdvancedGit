#!/usr/bin/ruby

# example usage: ruby one_step_back.rb
`git stash -u -k`
`git reset --mixed HEAD~` # staged changes become unstaged
`git reset --soft HEAD~1` # changes from last commit become staged
`git checkout HEAD~1`     # last commit becomes head

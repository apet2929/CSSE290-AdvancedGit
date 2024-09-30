#!/usr/bin/ruby

# example usage: ruby one_step_back.rb
`git stash -u -k`
`git reset`
`git reset --soft HEAD~1`

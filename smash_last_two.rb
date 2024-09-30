#!/usr/bin/ruby
# example usage: ruby smash_last_two.rb

`git stash -u` # ensure current changes aren't included in commit
`git reset --soft HEAD~2`
`git commit -m "SMASH"`
`git stash pop`
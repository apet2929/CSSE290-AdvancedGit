#!/usr/bin/ruby
# example usage: ruby smash_last_two.rb

`git stash -u` # ensure current changes aren't included in commit

log = `git log --pretty=oneline | head -2`
# example output: 
# 02a20d58c80b7ca4cabff30369fd75107c60649b (HEAD -> main, origin/main, origin/HEAD) Remove hw folder
# f06a6eaa493130a2574741d29d2729ff9d304dab Finish plumbing 2

commits = log.split '\n'
base_hash = commits.last.split(" ")[0]
`git reset --soft #{commit_hashes.last}`
`git commit `
``

`git stash pop`
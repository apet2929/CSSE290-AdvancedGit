#!/usr/bin/ruby
require 'optparse'

trees = []
output = nil
OptionParser.new do |opts|
  opts.on("-t TREE", "--tree TREE", "SHA of tree to include in history") do |val|
    trees << val
  end
  opts.on("-o OUTPUT_BRANCH", "--output OUTPUT_BRANCH", "branch that contains alternative history") do |val|
    output = val
  end
end.parse(ARGV)
raise "You must specify a tree (-t)" if trees.empty?
raise "You must an output branch" if output.nil?

# your code here
"""
1. commit with first tree using git commit-tree {tree}
2. commit with second tree using git commit-tree {tree} -p {hash from step 1}
3. repeat until no trees remain
4. create branch with git update-ref refs/heads/{branch} {hash from step 3}
"""

# 5cbdcbbf7fedddfc18f9a451da5b2178d65c6281 - tests
# d40370126d7d0f49510a621055fd616a6081d8c6 - ui-extension
# ruby ../alternate_history.rb -t 5cbdcbbf7fedddfc18f9a451da5b2178d65c6281 -t d40370126d7d0f49510a621055fd616a6081d8c6 -o alternate-history-branch

last_commit_hash = nil

while not trees.empty?
  # binding.pry
  tree = trees.pop
  if last_commit_hash.nil?
    last_commit_hash = `echo 'alternate history begin' | git commit-tree #{tree}`
  else
    last_commit_hash = `echo 'alternate history followup' | git commit-tree #{tree} -p #{last_commit_hash}`
  end
end

`git update-ref refs/heads/#{output} #{last_commit_hash}`
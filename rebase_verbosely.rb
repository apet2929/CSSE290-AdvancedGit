#!/usr/bin/ruby
require 'optparse'


new_base = nil
OptionParser.new do |opts|
  opts.on("-b BASE", "--base BASE", "New base to rebase to") do |val|
    new_base = val
  end
end.parse(ARGV)
raise "You must specify a new base (-b)" if new_base.nil?


old_log = `git log --oneline`
`git rebase #{new_base}`
new_log = `git log --oneline`

old_commits = old_log.split("\n").map do |commit|
  
end
#!/usr/bin/ruby
require 'optparse'

# example usage: ruby revert_except_file.rb 7e64813 README.md

options = OptionParser.new.parse!
file = ARGV.pop
commit_hash = ARGV.pop
temp_file_path = '/tmp/keep_for_restore'
`cp #{file} #{temp_file_path}`
`git reset --hard #{commit_hash}`
`cp #{temp_file_path} #{file}`
`rm #{temp_file_path}`
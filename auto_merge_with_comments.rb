#!/usr/bin/ruby
require 'optparse'

trees = []
output = nil
OptionParser.new do |opts|
  opts.on("--use USE", "SHA of tree to include in history") do |val|
<<<<<<< branch1
Here are some branchone changes
=======
Here's some branch2 changes
That span several lines
>>>>>>> branch2
    trees << val
  end
  opts.on("-o OUTPUT_BRANCH", "--output OUTPUT_BRANCH", "branch that contains alternative history") do |val|
    output = val
  end
end.parse(ARGV)
raise "You must specify a tree (-t)" if trees.empty?
raise "You must an output branch" if output.nil?
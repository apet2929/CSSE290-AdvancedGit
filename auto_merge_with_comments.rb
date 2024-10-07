#!/usr/bin/ruby
require 'optparse'

use = nil
commitify = nil
branch = nil
prefix = nil
OptionParser.new do |opts|
  opts.on("--use SHA", "this is the SHA of the commit that we want to use unmodified in case of conflicts") do |val|
    use << val
  end
  opts.on("--commitify SHA", "this the SHA of the commit we want to insert as comments only") do |val|
    commitify = val
  end
  opts.on("--branch NAME", "this is the name of the branch where the output will go") do |val|
    branch = val
  end
  opts.on("--prefix STRING", 'this is the prefix that will make a line a comment. So wed use "// " in C++ or "# " in ruby') do |val|
    prefix = val
  end
end.parse(ARGV)
raise "You must specify all arguments!" if use.nil? or commitify.nil? or branch.nil? or prefix.nil?

other_branch = "foobar"
`git reset --hard #{use}`
`git branch #{branch}`
`git reset --hard #{commitify}`
`git branch #{SecureRandom.hex(10)}`

`git branch -d `
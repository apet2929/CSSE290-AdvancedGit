#!/usr/bin/ruby
require 'optparse'


def commit_parts(commit_line) # hash, desc
  commit_hash = commit_line.split(" ")[0]
  commit_desc = commit_line[8, commit_line.length]
  if commit_desc[0] == "("
    commit_desc = commit_desc[commit_desc.index(")") + 2, commit_desc.length]
  end
  return [commit_hash, commit_desc]
end

def commit_with_desc(commits, desc)
  t = commits.filter do |c|
    c[1] == desc
  end
  if t.empty?
    nil
  else
    t.first
  end
end

# 7e64813
# 939a576
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

old_commit_lines = old_log.split("\n")
old_commits = old_commit_lines.map do |commit|
  commit_parts(commit)
end

new_commit_lines = new_log.split("\n")
new_commits = new_commit_lines.map do |commit|
  commit_parts(commit)
end


new_commits.each do |new_commit|
  old_commit = commit_with_desc(old_commits, new_commit[1])
  if new_commit
    if new_commit[0] == new_base
      puts "#{new_commit[0]} is the new base: #{new_commit[1]}"
      break
    end
    puts "#{old_commit[0]} becomes #{new_commit[0]}: #{old_commit[1]}"
  end
end

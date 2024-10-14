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


# old_log = `git log --oneline`
old_log = <<LOG
939a576 (HEAD) Fix output comparison in variablechecking
c72f4a5 Updated Skulpt; new option to turtle grader
8d9663f Merge pull request #21 from vkaravir/vartest-feedback-fix
8a1586c Merge pull request #20 from vkaravir/logging-fixes
d2e3233 Make toggle separator configurable
ce0b906 Fix coloring of variable values in variable checker feedback
283bb73 Fixes to logged data.
bebf70e Minor fixes to pseudocode, python variable handling, and executable code handling
3a17c6e Merge pull request #19 from vkaravir/turtlet-grader
b1b6576 Merge pull request #18 from vkaravir/python-exec-merge
9784638 Refactored python execution to be in only one place (VariableCheckGrader._python_exec)
179be36 Updated the pseudocode example to include the exchangeable toggle
daf7701 Allow different values to be specified for toggles in executable code
LOG


# rebase_logs = `git rebase #{new_base}`
rebase_logs = <<LOG
First, rewinding head to replay your work on top of it...
Applying: Fixes to logged data.
Applying: Fix coloring of variable values in variable checker feedback
Applying: Make toggle separator configurable
Applying: Updated Skulpt; new option to turtle grader
Applying: Fix output comparison in variablechecking
LOG

# new_log = `git log --oneline`
new_log = <<LOG
4df2969 (HEAD) Fix output comparison in variablechecking
3179e44 Updated Skulpt; new option to turtle grader
0b2d1b7 Make toggle separator configurable
e467ba1 Fix coloring of variable values in variable checker feedback
90e56b6 Fixes to logged data.
7e64813 Minor css fixes to prevent misbehaving in some environments
bebf70e Minor fixes to pseudocode, python variable handling, and executable code handling
3a17c6e Merge pull request #19 from vkaravir/turtlet-grader
b1b6576 Merge pull request #18 from vkaravir/python-exec-merge
0c26a0f Merge pull request #17 from vkaravir/pseudo-toggle-fix
f41fd53 (origin/turtlet-grader) Added a grader and an example for turtle graphics parsons
9784638 Refactored python execution to be in only one place (VariableCheckGrader._python_exec)
179be36 Updated the pseudocode example to include the exchangeable toggle
daf7701 Allow different values to be specified for toggles in executable code
LOG


commit_descs = []
rebase_logs.split("\n").each do |line|
  if line.include?("Applying:")
    commit_descs << line[10, line.length]
  end
end

old_commit_lines = old_log.split("\n")
old_commits = old_commit_lines[1, old_commit_lines.length].map do |commit|
  commit_parts(commit)
end
old_commits = old_commits.filter do |commit|
  commit_descs.include?(commit[1])
end

new_commit_lines = new_log.split("\n")
new_head = commit_parts(new_commit_lines[0])
new_commits = new_commit_lines[1, new_commit_lines.length].map do |commit|
  commit_parts(commit)
end.filter do |commit|
  commit_descs.include?(commit[1])
end

old_commits.each do |c|
  new_commit = commit_with_desc(new_commits, c[1])
  if new_commit
    puts "#{c[0]} becomes #{new_commit[0]}: #{c[1]}"
  end
end

puts "#{new_head[0]} is the new base: #{new_head[1]}"

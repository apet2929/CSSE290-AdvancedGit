#!/usr/bin/ruby
require 'optparse'

# ruby ../auto_merge_with_comments.rb --use d85f775 --commitify deeffdf --branch SomeOutput --prefix "XXXX "
use = nil
commitify = nil
branch = nil
prefix = nil
OptionParser.new do |opts|
  opts.on("--use SHA", "this is the SHA of the commit that we want to use unmodified in case of conflicts") do |val|
    use = val
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

# other_branch = (0...8).map { (65 + rand(26)).chr }.join
# puts other_branch
# `gi branch #{other_branch}`
# `git branch -d #{other_branch}`

`git reset --hard #{use}`
`git checkout -b #{branch}`
`git merge #{commitify}`

conflicts = `git diff --name-only --diff-filter=U`
conflicted_files = conflicts.split("\n")

conflicted_files.each do |file|
  puts file
  lines = File.readlines(file)

  # <<<<<<< HEAD
  # =======
  # >>>>>>> deeffdf
  in_use_changes = false
  in_commitify_changes = false

  output_lines = []

  lines.each do |line|
    if line.include?("<<<<<<<")
      in_use_changes = true
    elsif line.include?("=======")
      in_commitify_changes = true
      in_use_changes = false
    elsif line.include?(">>>>>>>")
      in_commitify_changes = false
    else
      # content
      if in_commitify_changes
        output_lines << prefix + line
      else
        output_lines << line
      end
    end
  end
  output = output_lines.join

  IO.write(file, output)
end

`git add .`
`git commit -m "Merge between #{use} and #{commitify}"`


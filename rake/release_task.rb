# coding: utf-8
# frozen_string_literal: true


##
## howto
##

desc "show how to release"
task :howto do
  puts <<'END'
How to release:

  $ git diff                     # confirm that no diff
  $ rake test
  $ rake prepare release=0.0.0   # update release number
  $ rake package                 # create gem file
  $ rake release                 # upload to rubygems.org
  $ git checkout .               # reset release number
  $ git tag | grep 0.0.0         # confirm release tag
  release-0.0.0
  $ git push --tags

END
end


##
## build
##

desc "update release number"
task :prepare do
  release = release_number_required(:prepare)
  edit(spec.files) {|s|
    s.gsub(/\$Release\:.*?\$/,   "$Release\: #{release} $") \
     .gsub(/\$Release\$/,        release)
  }
end

namespace :gem do

  desc "create gem package"
  task :build do
    sh "gem build #{PROJECT}.gemspec"
  end

  desc "upload gem to rubygems.org"
  task :publish => :build do
    spec = load_gemspec_file("#{PROJECT}.gemspec")
    release = spec.version
    gemfile = "#{PROJECT}-#{release}.gem"
    print "*** Are you sure to upload #{gemfile}? [y/N]: "
    answer = gets().strip()
    if answer =~ /\A[yY]/
      sh "gem push #{gemfile}"
      #sh "git tag release-#{release}"
      sh "git tag v#{release}"
    end
  end

end

def edit(*filepaths)
  filepaths.flatten.each do |fpath|
    next if ! File.file?(fpath)
    File.open(fpath, 'r+b:utf-8') do |f|
      s = f.read()
      new_s = yield s
      if new_s != s
        f.rewind()
        f.truncate(0)
        f.write(new_s)
        puts "[Change] #{fpath}"
      end
    end
  end
end

def load_gemspec_file(gemspec_file)
  require 'rubygems'
  return Gem::Specification::load(gemspec_file)
end

def release_number_required(task_name)
  release = ENV['release']
  unless release
    $stderr.puts <<"END"
##
## ERROR: rake #{task_name}: requires 'release=X.X.X' option.
##        For example:
##           $ rake #{task_name} release=1.0.0
##
END
    errmsg = "rake #{task_name}: requires 'release=X.X.X' option."
    raise ArgumentError.new(errmsg)
  end
  return release
end

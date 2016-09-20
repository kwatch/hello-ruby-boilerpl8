# -*- coding: utf-8 -*-


PROJECT = "hello"


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


##

task :default => :test


desc "run test scripts"
task :test do
  sh "ruby test/**/*_test.rb"
end


desc "update release number"
task :prepare do
  release = release_number_required(:prepare)
  spec = load_gemspec_file("#{PROJECT}.gemspec")
  edit(spec.files) {|s|
    s = s.gsub(/\$Release\:.*?\$/,   "$Release\: #{release} $")
    s = s.gsub(/\$Release\$/,        release)
    s
  }
end


desc "create gem package"
task :package => :prepare do
  release_number_required(:package)
  sh "gem build #{PROJECT}.gemspec"
end


desc "upload gem to rubygems.org"
task :release => :package do
  release = release_number_required(:release)
  spec = load_gemspec_file("#{PROJECT}.gemspec")
  sh "git tag release-#{spec.version}"
  sh "gem push #{PROJECT}-#{spec.version}.gem"
end

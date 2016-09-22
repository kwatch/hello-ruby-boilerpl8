# -*- coding: utf-8 -*-


PROJECT  = "hello"
SPECFILE = PROJECT + ".gemspec"


##
## tasks
##

task :default => :test


desc "run test scripts"
task :test do
  sh "ruby test/**/*_test.rb"
end


desc "update release number"
task :prepare do
  release = release_number_required(:prepare)
  edit(SPECFILE) {|s|
    s.sub(/(spec\.version[ \t]*=)[ \t]*('.*?'|".*?")/, "\\1 '#{release}'")
  }
  edit(spec.files) {|s|
    s.gsub(/\$Release\:.*?\$/,   "$Release\: #{release} $") \
     .gsub(/\$Release\$/,        release)
  }
end


desc "create gem package"
task :package do
  sh "gem build #{SPECFILE}"
end


desc "upload gem to rubygems.org"
task :release => :package do
  spec = load_gemspec_file(SPECFILE)
  release = spec.version
  print "*** Are you sure to upload #{PROJECT}-#{release}.gem? [y/N]: "
  answer = gets().strip()
  if answer =~ /\A[yY]/
    #sh "git tag v#{release}"
    sh "git tag release-#{release}"
    sh "gem push #{PROJECT}-#{release}.gem"
  end
end


##
## helpers
##

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

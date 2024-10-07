# -*- coding: utf-8 -*-


PROJECT  = "hello"
SPECFILE = PROJECT + ".gemspec"


##
## tasks
##

task :default => :howto    # or :test if you like


namespace :howto do

  namespace :release do

    desc "show how to release new version"
    task :new do
      puts <<'END'
How to create new release (= X.Y.0):

  $ git checkout -b rel-0.1      # create new branch on local
  $ git push -u origin rel-0.1   # push new branch to remote
  $ rake test
  $ rake prepare release=0.1.0   # update release number
  $ git diff
  $ git add
  $ git commit -m "release 0.1.0"
  $ git push
  $ rake package                 # create gem file
  $ rake publish                 # upload to rubygems.org
  $ git tag v0.1.0
  $ git push --tags

END
    end

    desc "show how to release bugfix version"
    task :bugfix do
      puts <<'END'
How to create bugfix release (= x.y.Z):

  $ git checkout rel-0.1         # switch to existing branch
  $ rake test
  $ rake prepare release=0.1.1   # update release number
  $ git diff
  $ git add
  $ git commit -m "release 0.1.1"
  $ rake package                 # create gem file
  $ rake publish                 # upload to rubygems.org
  $ git tag v0.1.1
  $ git push --tags

END
    end

  end

end


desc "run test scripts"
task :test do
  $LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
  #sh "ruby test/**/*_{test,spec}.rb"   # not work
  pattern = 'test/**/*_{test,spec}.rb'
  files = Dir.glob(pattern)
  files = [pattern] if files.empty?
  puts "ruby #{pattern}"
  sh "ruby", *files, :verbose=>false
end
### or
#require 'rake/testtask'
#Rake::TestTask.new do |test|
#  #test.libs << 'lib' << 'test'
#  test.test_files = Dir.glob('test/**/*_{test,spec}.rb')
#  test.verbose = true
#end


desc "update release number"
task :prepare do
  release = release_number_required(:prepare)
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
task :publish => :package do
  spec = load_gemspec_file(SPECFILE)
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

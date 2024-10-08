# coding: utf-8
# frozen_string_literal: true


##
## release:howto
##
desc "show how to release"
task "release:howto", [:version] do |t, args|
  version = args[:version] || ENV['version']  or
    fail "[ERROR] Version number required (such as 'version=1.0.0')."
  puts howto_release(PROJECT, version)
end

def howto_release(project, version)
  version =~ /\A(\d+\.\d+)/  or
    abort "#{version}: Invalid version number."
  ver = $1
  zero_p = ver.end_with?('.0')
  opt_b = zero_p ? " -b" : ""
  comm  = zero_p ? "create a new" : "switch to existing"
  return <<"END"
## How to release #{version}

git diff                	# confirm that there is no changes
rake test
rake test:all           	# test on Ruby 2.x ~ 3.x
git checkout#{opt_b} rel-#{ver}    	# #{comm} release branch
vi CHANGES.md
git add CHANGES.md
git commit -m "Update 'CHANGES.md'"
git log -1              	# confirm the commit
cid=$(git log -1 | awk 'NR==1{print $2}')  	# in order to cherry-pick later
rake prepare[#{version}]        	# update release number in files
git add -u .            	# add changes into staging area
git status -sb .        	# list files in staging area
git diff --cached       	# confirm changes in staging area
git commit -m "Preparation for release #{version}"
gem build #{project}.gemspec  	# build gem package
gem unpack #{project}-#{version}.gem 	# extract gem package
find #{project}-#{version}         	# confirm file list in gem package
rm -rf #{project}-#{version}       	# delete extracted files
gem push #{project}-#{version}.gem 	# release gem package
git push -u origin rel-#{ver}
git tag v#{version}             	# add version tag
git push --tags
git checkout -          	# back to main branch
git log -1 $cid
git cherry-pick $cid    	# apply the commit to update CHANGES.md
git rm #{project}-#{version}.gem   	# if necessary

END
end


##
## prepare
##
desc "update version number"
task :prepare, [:version] do |t, args|
  version = args[:version] || ENV['version']  or
    fail "[ERROR] Version number required (such as 'version=1.0.0')."
  copyright = COPYRIGHT
  spec = load_gemspec_file("#{PROJECT}.gemspec")
  edit_files(spec.files) {|s, fpath|
    s = s.gsub(/\$Version\:.*?\$/,   "$Version\: #{version} $")
    s = s.gsub(/\$Version\$/,        version)
    s = s.gsub(/\$Copyright:.*?\$/,  "$Copyright\: #{copyright} $")
    s = s.gsub(/\$Copyright\$/,      copyright)
    if fpath == "MIT-LICENSE"
      if copyright =~ /(\(c\).*)/
        x = $1
        s = s.sub(/^Copyright .*$/, "Copyright #{x}")
      end
    end
    s
  }
end

def edit_files(*filepaths)
  filepaths.flatten.each do |fpath|
    next unless File.file?(fpath)
    changed = edit_file(fpath)
    puts "[Change] #{fpath}" if changed
  end
end

def edit_file(fpath)
  changed = false
  File.open(fpath, 'r+b:utf-8') do |f|
    s = f.read()
    new_s = yield s, fpath
    if new_s != s
      f.rewind()
      f.truncate(0)
      f.write(new_s)
      changed = true
    end
  end
  return changed
end

def load_gemspec_file(gemspec_file)
  require 'rubygems'
  return Gem::Specification::load(gemspec_file)
end


##
## gem:build
##
desc "create gem package"
task "gem:build" do
  sh "gem build #{PROJECT}.gemspec"
end


##
## gem:upload
##
desc "upload gem to rubygems.org"
task "gem:publish" do
  spec = load_gemspec_file("#{PROJECT}.gemspec")
  version = spec.version.to_s
  gemfile = "#{PROJECT}-#{version}.gem"
  File.exist?(gemfile)  or
    abort "[ERROR] Gem file (#{gemfile}) not found. Run 'rake gem:build' beforehand."
  print "*** Are you sure to upload #{gemfile}? [y/N]: "
  answer = $stdin.gets().strip()
  if answer =~ /\A[yY]/
    sh "gem push #{gemfile}"
    sh "git tag v#{version}"
  end
end

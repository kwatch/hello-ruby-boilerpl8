# coding: utf-8
# frozen_string_literal: true


##
## test
##

desc "run test scripts"
task :test do
  ruby "test/all.rb"
end

desc "run test scripts on each Ruby version"
task "test:all" do
  pairs = ruby_path_list(ruby_root_dir(), ruby_versions())
  pairs.each do |(version, path)|
    puts "\e[33m========== Ruby #{version} ==========\e[0m"
    sh "#{path} test/all.rb" do end   # run forcedly
    puts ""
    sleep 0.2
  end
end

def ruby_versions()
  if ENV['RUBY_VERSIONS']
    return ENV['RUBY_VERSIONS'].split(",")
  elsif defined?(RUBY_VERSIONS)
    return RUBY_VERSIONS
  else
    fail "RUBY_VERSIONS should be set for 'test:all' task."
  end
end

def ruby_root_dir()
  vs_home = ENV['VS_HOME'] || (defined?(VS_HOME) && VS_HOME) || nil
  vs_home  or
    fail "$VS_HOME should be set for 'test:all' task."
  return "#{vs_home}/ruby"
end

def ruby_path_list(ruby_root_dir, ruby_versions)
  return ruby_versions.collect {|version|
    path = "#{ruby_root_dir}/#{version}/bin/ruby"
    if ! File.exist?(path)
      paths = Dir.glob("#{ruby_root_dir}/#{version}.*/bin/ruby")
      ! paths.empty?  or
        fail "Ruby #{version} not found."
      path = paths.sort_by {|x|
        x =~ /\/([^\/]+)\/bin\/ruby\z/
        $1.split('.').collect {|s| s.to_i }
      }.last
    end
    [version, path]
  }
end

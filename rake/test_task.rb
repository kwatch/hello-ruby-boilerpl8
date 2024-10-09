# encoding: utf-8
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
  header = "\e[33m========== Ruby %s ==========\e[0m"
  each_ruby_path(ruby_root_dir(), ruby_versions(), header) do |version, path|
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
  rbenv_root = ENV['RBENV_ROOT'] || (defined?(RBENV_ROOT) && RBENV_ROOT) || nil
  vs_home    = ENV['VS_HOME'] || (defined?(VS_HOME) && VS_HOME) || nil
  rbenv_dir  = File.expand_path("~/.rbenv")
  if rbenv_root && ! rb_env_root.empty?
    return "#{rbenv_root}/versions"
  elsif vs_home && ! vs_home.empty?
    return "#{vs_home}/ruby"
  elsif File.directory?(rbenv_dir)
    return "#{rbenv_dir}/versions"
  else
    fail "$RBENV_ROOT or $VS_HOME should be set for 'test:all' task."
  end
end

def each_ruby_path(ruby_root_dir, ruby_versions, header, &block)
  ruby_versions.each do |version|
    puts header % version
    path = "#{ruby_root_dir}/#{version}/bin/ruby"
    if ! File.exist?(path)
      path_pat = "#{ruby_root_dir}/#{version}.*/bin/ruby"
      paths = Dir.glob(path_pat)
      ! paths.empty?  or
        fail "Ruby #{version} not found. (#{path_pat})"
      path = paths.sort_by {|x|
        x =~ /\/([^\/]+)\/bin\/ruby\z/
        $1.split('.').collect {|s| s.to_i }
      }.last
    end
    yield version, path
  end
end

# -*- coding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name            = '<%= @project %>'
  spec.version         = '$Release: 0.1.0 $'.split()[1]
  spec.author          = 'YOUR NAME'
  spec.email           = 'yourname(at)example.com'
  spec.platform        = Gem::Platform::RUBY
  spec.homepage        = 'https://github.com/yourname/<%= @project %>'
  spec.summary         = "example scirpt to print 'Hello'"
  spec.description     = <<-'END'
This is an example project to create a script which just print 'Hello'.
END
  spec.license         = 'MIT'
  spec.files           = Dir[*%w[
                           README.md MIT-LICENSE Rakefile <%= @project %>.gemspec
                           bin/*
                           lib/**/*.rb
                           test/**/*.rb
                         ]]
  spec.executables     = ['hello']
  spec.bindir          = 'bin'
  spec.require_path    = 'lib'
  spec.test_files      = Dir['test/**/*_test.rb']
  #spec.extra_rdoc_files = ['README.rdoc', 'CHANGES.md']

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-ok'
end

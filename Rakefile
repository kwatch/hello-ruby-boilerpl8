# coding: utf-8
# frozen_string_literal: true


PROJECT       = "hello"
COPYRIGHT     = "copyright(c) 2024 YOUR_NAME"

RUBY_VERSIONS = ['3.3', '3.2', '3.1', '3.0', '2.7', '2.6']  # for 'test:all' task

task :default => :help   # or :test if you prefer

require_relative "./rake/init"
Dir.glob("rake/*_task.rb").sort.each do |fpath|
  require_relative "./#{fpath}"
end

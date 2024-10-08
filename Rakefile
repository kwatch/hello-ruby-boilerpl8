# -*- coding: utf-8 -*-


PROJECT  = "hello"

task :default => :help   # or :test if you prefer

Dir.glob("rake/*_task.rb").sort.each do |fpath|
  require_relative "./#{fpath}"
end

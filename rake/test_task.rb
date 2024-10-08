# coding: utf-8
# frozen_string_literal: true


##
## test
##

desc "run test scripts"
task :test do
  ruby "test/all.rb"
end

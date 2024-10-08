# coding: utf-8
# frozen_string_literal: true


require_relative './init'

testdir = File.dirname(__FILE__)
Dir.glob(File.join(testdir, "**/*_test.rb")).sort.each do |fpath|
  #require File.absolute_path(fpath)
  require_relative fpath.sub(testdir, ".")
end

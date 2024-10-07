# coding: utf-8
# frozen_string_literal: true


testdir = File.dirname(__FILE__)
libdir  = File.absolute_path(File.join(File.dirname(testdir), "lib"))
$LOAD_PATH << libdir unless $LOAD_PATH.include?(libdir)

Dir.glob(File.join(testdir, "**/*_test.rb")).sort.each do |fpath|
  #require File.absolute_path(fpath)
  require_relative fpath.sub(testdir, ".")
end

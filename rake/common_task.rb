# coding: utf-8
# frozen_string_literal: true


##
## help
##

desc "list task names"
task :help do
  system "rake -T"
end


##
## clean
##

desc "delete garbage files"
task :clean do
  rm_f Dir.glob(GARBAGE_FILES)
end

desc "delete product files as well as garbage files"
task "clean:all" => :clean do
  rm_f Dir.glob(PRODUCT_FILES)
end

GARBAGE_FILES = ["**/*~", "#{PROJECT}-*.*.*/"]
PRODUCT_FILES = ["#{PROJECT}-*.gem"]

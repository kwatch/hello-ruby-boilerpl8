# -*- coding: utf-8 -*-

require 'erb'
require 'etc'


def run

  ## context values
  @project = File.basename(Dir.pwd)             # project name
  @user    = ENV['USER'] || Etc.getlogin()      # user name

  ## render template
  files = ['hello.gemspec', 'MIT-LICENSE']
  files.each do |fname|
    s = File.read(fname)
    new_s = ERB.new(s).result(binding)
    if new_s != s
      File.write(fname, new_s)
    end
  end

  ## edit project name in Rakefile
  File.open('Rakefile', 'r+') do |f|
    s = f.read()
    s = s.sub(/(PROJECT += +)\S+/, "\\1'#{@project}'")
    f.rewind()
    f.truncate(0)
    f.write(s)
  end

  ## rename gemspec file
  puts "$ mv hello.gemspec #{@project}.gemspec"
  File.rename "hello.gemspec", "#{@project}.gemspec"

  ## remove
  puts "$ rm __init.rb"
  File.unlink "__init.rb"

end


if __FILE__ == $0
  run()
end

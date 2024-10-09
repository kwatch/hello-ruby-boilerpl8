# coding: utf-8
# frozen_string_literal: true

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/ok'
require 'stringio'

testdir = File.dirname(__FILE__)
libdir  = File.absolute_path(File.dirname(testdir) + "/lib")
$LOAD_PATH << libdir unless $LOAD_PATH.include?(libdir)

require 'hello'


## Note: in MiniTest, describe() is defined in Kernel module.
unless Kernel.private_methods.include?(:context)
  alias context describe
end


MiniTest::Assertions.module_eval do

  def capture_stdio(input="", tty: false)
    bkup = [$stdin, $stdout, $stderr]
    $stdin  = StringIO.new(input)
    $stdout = StringIO.new
    $stderr = StringIO.new
    if tty
      def $stdin.tty?  ; true; end
      def $stdout.tty? ; true; end
      def $stderr.tty? ; true; end
    end
    yield
    return $stdout.string, $stderr.string
  ensure
    $stdout, $stdout, $stderr = bkup
  end

end

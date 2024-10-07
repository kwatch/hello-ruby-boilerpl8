# -*- coding: utf-8 -*-

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/ok'
require 'stringio'

require 'hello'


## Note: in MiniTest, describe() is defined in Kernel module.
unless Kernel.private_methods.include?(:context)
  alias context describe
end


MiniTest::Assertions.module_eval do

  def capture_io
    bkup = [$stdout, $stderr]
    $stdout = StringIO.new
    $stderr = StringIO.new
    begin
      yield
      return [$stdout.string, $stderr.string]
    ensure
      $stdout, $stderr = bkup
    end
  end

end

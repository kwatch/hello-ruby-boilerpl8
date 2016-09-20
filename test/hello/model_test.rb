# -*- coding: utf-8 -*-

require_relative '../test_helper'


describe Hello::Model do


  describe '#message()' do

    it "returns message string." do
      ok {Hello::Model.new.message()} == "Hello, World!"
    end

    it "takes user name." do
      ok {Hello::Model.new.message("Mitsuba")} == "Hello, Mitsuba!"
    end

  end


end

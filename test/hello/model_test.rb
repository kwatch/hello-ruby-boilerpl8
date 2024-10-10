# encoding: utf-8
# frozen_string_literal: true

require_relative '../init'


describe Hello::Model do


  describe '#initialize()' do

    it "uses 'en' as a default language." do
      ok {Hello::Model.new.lang} == "en"
    end

    it "raises error if unknown language specified." do
      exc = assert_raises(ArgumentError) do
        Hello::Model.new("ja")
      end
      ok {exc.message} == "ja: Unknown language."
      ### or:
      #pr = proc { Hello::Model.new("ja") }
      #ok {pr}.raise?(RuntimeError, "ja: Unknown language.")
    end

  end


  describe '#message()' do

    it "returns message string according to language." do
      ok {Hello::Model.new("en").message()} == "Hello, World!"
      ok {Hello::Model.new("fr").message()} == "Bonjour, World!"
      ok {Hello::Model.new("it").message()} == "Chao, World!"
    end

    it "takes user name." do
      ok {Hello::Model.new.message("Mitsuba")} == "Hello, Mitsuba!"
      ok {Hello::Model.new("fr").message("Mitsuba")} == "Bonjour, Mitsuba!"
    end

  end


end

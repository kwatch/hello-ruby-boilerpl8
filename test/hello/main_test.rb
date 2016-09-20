# -*- coding: utf-8 -*-

require_relative '../test_helper'


describe Hello::Main do


  describe '#run()' do

    it "prints hello message to stdout." do
      expected = "Hello, World!\n"
      assert_output(expected) { Hello::Main.new.run() }
    end

    it "takes user name." do
      expected = "Hello, Taki!\n"
      assert_output(expected) { Hello::Main.new.run("Taki") }
    end


    context "when '-h' or '--help' specified" do

      it "prints help message to stdout." do
        expected = <<"END"
Usage: #{File.basename($0)} [OPTIONS] [NAME]
    -h, --help                       print help message
    -v, --version                    print version
    -n, --name=NAME                  user name
END
        assert_output(expected) { Hello::Main.new.run("-hv") }
        assert_output(expected) { Hello::Main.new.run("--help") }
      end

      it "returns status code 0." do
        status = nil
        capture_io { status = Hello::Main.new.run("-hv") }
        ok {status} == 0
        capture_io { status = Hello::Main.new.run("--help") }
        ok {status} == 0
      end

    end


    context "when '-v' or '--version' specified" do

      it "prints version number to stdout." do
        expected = "#{Hello::RELEASE}\n"
        assert_output(expected) { Hello::Main.new.run("-v") }
        assert_output(expected) { Hello::Main.new.run("--version") }
      end

      it "returns status code 0." do
        status = nil
        capture_io { status = Hello::Main.new.run("-vv") }
        ok {status} == 0
        capture_io { status = Hello::Main.new.run("--version") }
        ok {status} == 0
      end

    end


    context "when '-n NAME' or '--name=NAME' specified" do

      it "prints NAME instead of default name." do
        assert_output("Hello, Taki!\n")    { Hello::Main.new.run("-n", "Taki") }
        assert_output("Hello, Mitsuba!\n") { Hello::Main.new.run("--name=Mitsuba") }
      end

    end


  end


  describe '.main()' do

    it "exists 0 when finished successfully." do
      pr = proc { Hello::Main.main([]) }
      ex = nil
      output, errmsg = capture_io do
        ex = ok {pr}.raise?(SystemExit)
      end
      ok {ex.status} == 0
      ok {output} == "Hello, World!\n"
      ok {errmsg} == ""
    end

    it "exists 1 when command-option is worng." do
      pr = proc { Hello::Main.main(['-x']) }
      ex = nil
      output, errmsg = capture_io do
        ex = ok {pr}.raise?(SystemExit)
      end
      ok {ex.status} == 1
      ok {output} == ""
      ok {errmsg} == "#{File.basename($0)}: invalid option: -x\n"
    end

  end


end

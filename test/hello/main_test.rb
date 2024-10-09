# encoding: utf-8
# frozen_string_literal: true

require_relative '../init'


describe Hello::Main do

  before do
    @main = Hello::Main.new
  end


  describe '#run()' do

    it "prints hello message to stdout." do
      expected = "Hello, World!\n"
      assert_output(expected) { @main.run() }
    end

    it "takes user name." do
      expected = "Hello, Taki!\n"
      assert_output(expected) { @main.run("Taki") }
    end

    context "when '-h' or '--help' specified..." do

      it "prints help message to stdout." do
        expected = <<"END"
Usage: #{File.basename($0)} [<options>] [<name>]

Options:
  -h, --help                print help message
      --version             print version
  -l, --lang=<lang>         language (en|fr|it)
END
        assert_output(expected) { @main.run("-hv") }
        assert_output(expected) { @main.run("--help") }
      end

    end

    context "when '-v' or '--version' specified..." do

      it "prints version number to stdout." do
        expected = "#{Hello::VERSION}\n"
        assert_output(expected) { @main.run("-v") }
        assert_output(expected) { @main.run("--version") }
      end

    end

    context "when '-l <lang>' or '--lang=<lang>' specified..." do

      it "prints a message according to language." do
        assert_output("Bonjour, World!\n") { @main.run("-l", "fr") }
        assert_output("Chao, World!\n")    { @main.run("--lang=it") }
      end

    end

  end


  describe '.main()' do

    it "returns 0 when finished successfully." do
      ret = nil
      sout, serr = capture_io() do
        ret = Hello::Main.main([])
      end
      ok {ret}  == 0
      ok {sout} == "Hello, World!\n"
      ok {serr} == ""
    end

    it "exists 1 when command-option is worng." do
      ret = nil
      sout, serr = capture_io() do
        ret = Hello::Main.main(['-x'])
      end
      ok {ret}  == 1
      ok {sout} == ""
      ok {serr} == "[ERROR] invalid option: -x\n"
    end

  end


end

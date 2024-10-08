# -*- coding: utf-8 -*-


require 'optparse'


module Hello


  VERSION = '$Version: 0.1.0 $'.split()[1]


  class Model

    DEFAULT_NAME = "World"

    def message(name=nil)
      name ||= DEFAULT_NAME
      return "Hello, #{name}!"
    end

  end


  class Main

    def self.main(argv=ARGV)
      begin
        status = self.new.run(*argv)
      rescue OptionParser::InvalidOption => ex
        script = File.basename($0)
        $stderr.puts "#{script}: #{ex.message}"
        status = 1
      end
      exit(status)
    end

    def run(*args)
      options = {}
      parser = option_parser(options)
      parser.parse!(args)
      #
      if options[:help]
        puts parser.help()
        return 0
      end
      #
      if options[:version]
        puts VERSION
        return 0
      end
      #
      name = args[0] || options[:name]
      msg = Model.new.message(name)
      puts msg
      return 0
    end

    private

    def option_parser(options)
      script = File.basename($0)
      parser = OptionParser.new
      parser.banner = "Usage: #{script} [OPTIONS] [NAME]"
      parser.on("-h", "--help", "print help message") { options[:help] = true }
      parser.on("-v", "--version", "print version") { options[:version] = true }
      parser.on("-n", "--name=NAME", "user name") {|v| options[:name] = v }
      return parser
    end

  end


end


if __FILE__ == $0
  Hello::Main.main()
end

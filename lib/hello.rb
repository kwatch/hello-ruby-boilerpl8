# -*- coding: utf-8 -*-


require 'optparse'


module Hello


  VERSION = '$Version: 0.1.0 $'.split()[1]


  class BaseError < StandardError
  end

  class CommandError < BaseError
  end


  class Model

    DEFAULT_NAME = "World"

    def initialize(lang=nil)
      lang ||= "en"
      case lang
      when "en", "fr", "it";   # ok
      else
        raise "#{lang}: Unknown language."
      end
      @lang = lang
    end
    attr_reader :lang

    def message(name=nil)
      name ||= DEFAULT_NAME
      case lang
      when "en" ; return "Hello, #{name}!"
      when "fr" ; return "Bonjour, #{name}!"
      when "it" ; return "Chao, #{name}!"
      else
        raise "** internal error: lang=#{lang}"
      end
    end

  end


  class Main

    def initialize(command=nil)
      @command = command || File.basename($0)
    end
    attr_reader :command

    def self.main(argv=ARGV, command: nil)
      self.new(command).run(*argv)
      return 0
    rescue OptionParser::InvalidOption, BaseError => ex
      $stderr.puts "[ERROR] #{ex.message}"
      return 1
    end

    def run(*args)
      options = {}
      parser = new_option_parser(options)
      #parser.parse!(args)
      parser.permute!(args)   # or .order!()
      #
      done = handle_options(options)
      return if done
      #
      case args.length
      when 0 ; name = nil
      when 1 ; name = args[0]
      else   ; raise CommandError, "Too many arguments (max: 1)."
      end
      model = Model.new(options[:lang])
      puts model.message(name)
    end

    protected

    OPTION_SCHEMA = {
      :help    => ["-h", "--help", "print help message"],
      :version => [      "--version", "print version"],
      :lang    => ["-l", "--lang=<lang>", "language (en|fr|it)", ["en", "fr", "it"]],
    }

    def new_option_parser(options, *args)
      parser = OptionParser.new(*args)
      OPTION_SCHEMA.each do |key, arr|
        #if arr.include?(:multiple)
        #  arr = arr.dup
        #  arr.delete(:multiple)
        #  parser.on(*arr) {|v| (options[key] ||= []) << v }
        #else
          parser.on(*arr) {|v| options[key] = v }
        #end
      end
      return parser
    end

    def handle_options(options)
      if options[:help]
        print render_help_message()
        return true
      end
      if options[:version]
        puts VERSION
        return true
      end
      return false
    end

    def render_help_message(width: 25, indent: "  ")
      parser = new_option_parser({}, nil, width, indent)
      #parser.banner = "Usage: #{@command} [<options>] [<name>]"
      #return parser.help()
      ### or
      buf = []
      buf << "Usage: #{@command} [<options>] [<name>]\n"
      buf << "\n"
      buf << "Options:\n"
      buf << parser.summarize()
      return buf.join()
    end

  end


end


if __FILE__ == $0
  status = Hello::Main.main()
  exit status    # 0 or 1
end

# coding: euc-jp
# frozen_string_literal: true


if defined?(Rake)

  ## set prompt for FileUtils commands
  prompt = "\e[90m[rake]\e[0m$ "     if $stdout.tty?
  prompt = "[rake]$ "            unless $stdout.tty?
  @fileutils_label = prompt
  Rake.instance_variable_set(:@fileutils_label, prompt)

  ## set prompt for 'sh()' command
  Rake::FileUtilsExt.module_eval do
    def rake_output_message(message)
      fu_output_message(message)
    end
  end

end

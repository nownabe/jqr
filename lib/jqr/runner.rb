module Jqr
  class Runner
    attr_reader :arguments

    def initialize(arguments = ARGV)
      @arguments = arguments
    end

    def command_class
      case
      when options.help?
        Commands::Help
      when options.version?
        Commands::Version
      else
        Commands::Runner
      end
    end

    def run
      command_class.new(options).run
    end

    private

    def options
      @options ||= Slop.parse(arguments) do |o|
        o.banner = "Usage: cat JSON | jqr [options] QUERY"

        o.bool "-v", "--version", "Print the version"
        o.bool "-h", "--help", "Show this message"
        o.bool "--color", "Enable colorful output"
      end
    end
  end
end

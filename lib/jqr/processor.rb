module Jqr
  class Processor
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def run
      puts output
    end

    private

    def colorful?
      !options[:"no-color"]
    end

    def colorize(txt)
      txt
        .gsub(/(?<key>".+"):/) { "#{CE.fg(:h_blue).get(Regexp.last_match[:key])}:" }
        .gsub(/: (?<val>".+")/) { ": #{CE.fg(:green).get(Regexp.last_match[:val])}" }
    end

    def input
      STDIN.read
    end

    def input_json
      JSON.parse(input).with_indifferent_access
    end

    def output
      case processed_data
      when Hash
        tty? && colorful? ? colorize(pretty_json) : pretty_json
      when String, Numeric, TrueClass, FalseClass
        processed_data
      else
        PP.pp(processed_data, "")
      end
    end

    def pretty_json
      JSON.pretty_generate(processed_data)
    end

    def processed_data
      @oprocessed_data ||=
        queries.inject(input_json) { |json, query| eval("json#{query}") }
    end

    def queries
      @queries ||= options.arguments
    end

    def tty?
      STDOUT.tty?
    end
  end
end

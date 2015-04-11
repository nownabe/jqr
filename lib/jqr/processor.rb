module Jqr
  class Processor
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def run
      json = queries.inject(input_json) { |json, query| eval("json#{query}") }
      json =
        case json
        when Hash
          pretty = JSON.pretty_generate(json)
          if STDOUT.tty?
            pretty
              .gsub(/(?<key>".+"):/) { "#{CE.fg(:h_blue).get(Regexp.last_match[:key])}:" }
              .gsub(/: (?<val>".+")/) { ": #{CE.fg(:green).get(Regexp.last_match[:val])}" }
          else
            pretty
          end
        when String, Numeric, TrueClass, FalseClass
          json
        else
          PP.pp(json, "")
        end

      puts json
    end

    private

    def input_json
      JSON.parse(input).with_indifferent_access
    end

    def queries
      @queries ||= options.arguments
    end

    def input
      STDIN.read
    end
  end
end

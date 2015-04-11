module Jqr
  module Commands
    class Runner < Base
      def run
        Processor.new(options).run
      end
    end
  end
end

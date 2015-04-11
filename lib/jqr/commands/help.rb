module Jqr
  module Commands
    class Help < Base
      def run
        puts options
        exit
      end
    end
  end
end

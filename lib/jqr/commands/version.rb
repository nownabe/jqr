module Jqr
  module Commands
    class Version < Base
      def run
        puts Jqr::VERSION
        exit
      end
    end
  end
end

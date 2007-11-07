module Ambition
  module Adapters
    module ActiveRecord
      class Slice < Base
        def slice(start, length)
          out  = "LIMIT #{length} "
          out << "OFFSET #{start}" if start.to_i.nonzero?
          out
        end
      end
    end
  end
end

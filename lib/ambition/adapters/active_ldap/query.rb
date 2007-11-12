module Ambition
  module Adapters
    module ActiveLdap
      class Query

        def kick
          owner.find(:all, to_hash)
        end

        def size
          raise "Not Implemented"
        end

        def to_hash
          hash = {}
          hash[:filter] = to_s unless to_s.empty?
          hash
        end

        def to_s
          Array(clauses[:select]).join
          clauses[:select].first.to_s
        end
      end
    end
  end
end

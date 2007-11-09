module Ambition
  module Adapters
    module LDAP
      class Query

        attr_reader :context
        def initialize(context)
          @context = context
        end

        def kick
          @context.owner.find(:all, to_hash)
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
          Array(@context.clauses[:select]).join
          @context.clauses[:select].first.to_s
        end
      end
    end
  end
end

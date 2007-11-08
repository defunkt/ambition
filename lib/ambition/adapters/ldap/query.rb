module Ambition
  module Adapters
    module LDAP
      class Query
        def initialize(owner, clauses)
          @owner   = owner
          @clauses = clauses
        end

        def kick
          @owner.find(:all, to_hash)
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
          Array(@clauses[:select]).map { |clause| clause.to_s }.join
          @clauses[:select].first.to_s
        end
      end
    end
  end
end

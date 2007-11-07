module Ambition
  module Adapters
    module LDAP
      class Query
        def initialize(owner, clauses)
          @owner   = owner
          @clauses = clauses
        end

        def kick
        end

        def size
        end

        def to_hash
        end

        def to_s
          Array(@clauses[:select]).map { |clause| clause.to_s }.join
          @clauses[:select].first.to_s
        end
      end
    end
  end
end

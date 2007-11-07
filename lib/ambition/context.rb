module Ambition
  class Context
    include API

    def initialize(owner)
      @owner   = owner
      @clauses = {}
    end

    def ambition_context
      self
    end

    def <<(clause)
      @clauses[clause.key] ||= []
      @clauses[clause.key] << clause
      self
    end

    def adapter_query
      @owner.ambition_adapter::Query.new(@owner, @clauses)
    end

    def to_hash
      adapter_query.to_hash
    end

    def to_s
      adapter_query.to_s
    end

    def kick
      adapter_query.kick
    end

    def size
      adapter_query.size
    end
    alias_method :length, :size

    def inspect
      "(Query object: call #to_s or #to_hash to inspect, call an Enumerable (such as #each or #first) to request data)"
    end
  end
end

module Ambition
  class Context
    include API

    ##
    # These are the methods your Query class will want access to.
    #
    #   +owner+   is the class everything was called on.  Like `User' 
    #   +clauses+ is a hash of arrays, one key per processor.
    #             So, if someone called User.select, your
    #             +clauses+ hash would have a :select key with
    #             an array of translated strings via your Select
    #             class.
    attr_reader :clauses, :owner

    def initialize(owner)
      @owner   = owner
      @clauses = {}
      @hash    = {}
    end

    def ambition_context
      self
    end

    def <<(clause)
      @clauses[clause.key] ||= []
      @clauses[clause.key] << clause
      self
    end

    def [](key)
      @hash[key]
    end

    def []=(key, value)
      @hash[key] = value
    end

    def adapter_query
      @owner.ambition_adapter::Query.new(self)
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

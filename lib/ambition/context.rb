module Ambition
  class Context
    include API

    ##
    # These are the methods your Query and Translator classes will 
    # want to access.
    #
    #   +owner+   The class everything was called on.  Like `User' 
    #
    #   +clauses+ A hash of arrays, one key per processor.
    #             So, if someone called User.select, your
    #             +clauses+ hash would have a :select key with
    #             an array of translated strings via your Select
    #             class.
    #
    #   +stash+   A place for you to stick stuff.  Available to
    #             all Translators and your Query class.
    attr_reader :clauses, :owner, :stash

    def initialize(owner)
      @owner   = owner
      @clauses = {}
      @stash   = {}
    end

    def ambition_context
      self
    end

    def <<(clause)
      @clauses[clause.key] ||= []
      @clauses[clause.key] << clause.to_s
      self
    end

    def adapter_query
      Processors::Base.translator(self, :Query)
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

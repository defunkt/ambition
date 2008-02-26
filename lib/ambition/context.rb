module Ambition
  class Context
    undef_method :to_s
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

    def method_missing(method, *args, &block)
      return super unless adapter_query.respond_to? method
      adapter_query.send(method, *args, &block)
    end

    def inspect
      "(Query object: call #to_s or #to_hash to inspect, call an Enumerable (such as #each or #first) to request data)"
    end
  end
end

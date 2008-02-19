module Ambition #:nodoc:
  # This class includes several methods you will likely want to be accessing through your
  # Query and Translator classes:
  #
  # * +clauses+
  # * +owner+
  # * +stash+
  class Context
    undef_method :to_s
    include API
    
    # A hash of arrays, one key per processor.
    # So, if someone called User.select, your
    # +clauses+ hash would have a :select key with
    # an array of translated strings via your Select
    # class.
    # 
    # This is accessible from your Query and Translator classes.
    attr_reader :clauses
    
    # The class everything was called on.  Like `User`
    #
    # This is accessible from your Query and Translator classes.
    attr_reader :owner
    
    # A place for you to stick stuff.  Available to all Translators and your Query class.
    #
    # This is accessible from your Query and Translator classes.
    attr_reader :stash

    def initialize(owner)
      @owner   = owner
      @clauses = {}
      @stash   = {}
    end

    # Gets the ambition_context. From a Ambition::Context, this is actually +self+.
    def ambition_context
      self
    end

    # Adds a clause to this context.
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

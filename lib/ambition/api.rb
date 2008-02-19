module Ambition #:nodoc:
  # Module that you will extend from in your adapters in your toplevel file.
  # 
  # For example, for ambitious_sphinx in lib/ambition/adapters/ambitious_sphinx.rb, we have:
  #   ActiveRecord::Base.extend Ambition::API
  module API
    include Enumerable

    ##
    # Entry methods
    def select(&block)
      context = ambition_context 
      context << Processors::Select.new(context, block)
    end

    def sort_by(&block)
      context = ambition_context 
      context << Processors::Sort.new(context, block)
    end

    # Entries that our context is able to find.
    def entries
      ambition_context.kick
    end
    alias_method :to_a, :entries

    def size
      ambition_context.size
    end

    def slice(start, length = nil)
      context = ambition_context 
      context << Processors::Slice.new(context, start, length)
    end
    alias_method :[], :slice

    ##
    # Convenience methods
    
    # See Enumerable#detect
    def detect(&block)
      select(&block).first
    end

    # See Array#first
    def first(count = 1)
      sliced = slice(0, count)
      count == 1 ? Array(sliced.kick).first : sliced
    end

    # See Array#each, applied to +entries+
    def each(&block)
      entries.each(&block)
    end

    # See Enumerable#any?
    def any?(&block)
      select(&block).size > 0
    end

    # See Enumerable#all?
    def all?(&block)
      size == select(&block).size
    end

    # See Array#empty?
    def empty?
      size.zero?
    end


    # Builds a new +Context+.
    def ambition_context
      Context.new(self)
    end

    # Gives you the current ambitious adapter.
    def ambition_adapter
      name   = respond_to?(:name) ? name : self.class.name
      parent = respond_to?(:superclass) ? superclass : self.class.superclass
      @@ambition_adapter[name] || @@ambition_adapter[parent.name]
    end

    
    # Assign the ambition adapter. Typically, you use this in the toplevel file of your adapter.
    #
    # For example, for ambitious_sphinx, in our lib/ambition/adapters/ambitious_sphinx.rb:
    #
    #   ActiveRecord::Base.ambition_adapter = Ambition::Adapters::AmbitiousSphinx
    def ambition_adapter=(klass)
      @@ambition_adapter ||= {}
      # should this be doing the same check for respond_to?(:name) like above?
      @@ambition_adapter[name] = klass
    end

    def ambition_owner
      @owner || self
    end
  end
end

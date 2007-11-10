module Ambition
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

    def entries
      ambition_context.kick
    end
    alias_method :to_a, :entries

    def size
      ambition_context.size
    end

    def slice(start, length = nil)
      if start.is_a? Range
        length  = start.end
        length -= 1 if start.exclude_end?
        start = start.first
        length -= start
      end

      context = ambition_context 
      context << Processors::Slice.new(context, start, length)
    end
    alias_method :[], :slice

    ##
    # Convenience methods
    def detect(&block)
      select(&block).first
    end

    def first(count = 1)
      sliced = slice(0, count)
      count == 1 ? sliced.kick : sliced
    end

    def each(&block)
      entries.each(&block)
    end

    def any?(&block)
      select(&block).size > 0
    end

    def all?(&block)
      size == select(&block).size
    end

    def empty?
      size.zero?
    end

    ##
    # Plumbing
    def ambition_context
      Context.new(self)
    end

    def ambition_adapter
      name   = respond_to?(:name) ? name : self.class.name
      parent = respond_to?(:superclass) ? superclass : self.class.superclass
      @@ambition_adapter[name] || @@ambition_adapter[parent.name]
    end

    def ambition_adapter=(klass)
      @@ambition_adapter ||= {}
      @@ambition_adapter[name] = klass
    end

    def ambition_owner
      @owner || self
    end
  end
end

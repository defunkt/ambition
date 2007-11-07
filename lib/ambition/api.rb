module Ambition
  module API
    AmbitionEnumerable = Enumerable.dup
    AmbitionEnumerable.class_eval { remove_method :find; remove_method :find_all }
    include AmbitionEnumerable

    ##
    # Entry methods
    def select(&block)
      ambition_context << Processors::Select.new(ambition_owner, block)
    end

    def sort_by(&block)
      ambition_context << Processors::Sort.new(ambition_owner, block)
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

      ambition_context << Processors::Slice.new(ambition_owner, start, length)
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
      @@ambition_adapter[name] || @@ambition_adapter[superclass.name]
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

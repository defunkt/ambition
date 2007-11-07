module Ambition
  module API
    def select(&block)
      ambition_context << Processors::Select.new(ambition_owner, block)
    end

    def sort_by(&block)
      ambition_context << Processors::Sort.new(ambition_owner, block)
    end

    def entries
      kick
    end
    alias_method :to_a, :entries

    def first(count = 1)
      sliced = slice(0, count)
      count == 1 ? sliced.kick : sliced
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

    def ambition_owner
      @owner || self
    end

    def detect(&block)
      select(&block).first
    end

    def ambition_context
      Context.new(self)
    end

    def ambition_adapter
      @@ambition_adapter
    end

    def ambition_adapter=(klass)
      @@ambition_adapter = klass
    end
  end
end

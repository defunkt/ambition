module Ambition
  module Limit
    def first(limit = 1)
      query_context.add LimitProcessor.new(limit)

      if limit == 1
        find(:first, query_context.to_hash)
      else
        query_context
      end
    end

    def slice(offset, limit = nil)

      if offset.is_a? Range
        limit  = offset.end
        limit -= 1 if offset.exclude_end?
        offset = offset.first
        limit -= offset
      elsif limit.nil?
        return find(offset)
      end

      query_context.add OffsetProcessor.new(offset)
      query_context.add LimitProcessor.new(limit)
    end
    alias_method :[], :slice
  end

  class LimitProcessor 
    def initialize(limit)
      @limit = limit
    end

    def key
      :limit
    end

    def to_s
      @limit
    end
  end

  class OffsetProcessor
    def initialize(offset)
      @offset = offset
    end

    def key
      :offset
    end

    def to_s
      @offset
    end
  end
end

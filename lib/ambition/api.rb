module Ambition
  module API
    include Enumerable

    attr_accessor :query_context 
    def query_context
      @query_context || Query.new(self)
    end

    def entries
      find(:all, query_context.to_hash)
    end
    alias_method :to_a, :entries

    def select(*args, &block)
      query_context.add SelectProcessor.new(self, block)
    end

    def first(limit = 1)
      query_context.add SimpleProcessor.new(:limit => limit)

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

      query_context.add SimpleProcessor.new(:offset => offset)
      query_context.add SimpleProcessor.new(:limit  => limit)
    end
    alias_method :[], :slice

    def sort_by(&block)
      query_context.add SortProcessor.new(self, block)
    end

    def detect(&block)
      select(&block).first
    end

    def size
      count(query_context.to_hash)
    end
    alias_method :length, :size

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
  end
end

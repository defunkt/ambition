module Ambition
  module Enumerable
    include ::Enumerable

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

    def entries
      find(:all, query_context.to_hash)
    end
    alias_method :to_a, :entries
  end
end

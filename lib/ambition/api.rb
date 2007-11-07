module Ambition
  module API
    def select(&block)
      ambition_context << Processors::Select.new(ambition_owner, block)
    end

    def sort_by(&block)
      ambition_context << Processors::Sort.new(ambition_owner, block)
    end

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

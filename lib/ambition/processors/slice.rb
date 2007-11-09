module Ambition
  module Processors
    class Slice < Base
      def initialize(context, start, length)
        @context = context
        @start   = start
        @length  = length
        @slicer  = new_api_instance
      end

      def to_s
        @slicer.slice(@start, @length)
      end
    end
  end
end

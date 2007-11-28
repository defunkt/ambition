module Ambition
  module Processors
    class Slice < Base
      def initialize(context, start, length=nil)
        @context = context
        @start   = start
        @length  = length
      end

      def to_s
        translator.slice(@start, @length)
      end
    end
  end
end

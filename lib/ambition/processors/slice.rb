module Ambition
  module Processors
    class Slice < Base
      def initialize(owner, start, length)
        @owner  = owner
        @start  = start
        @length = length
        @slicer = new_api_instance(@owner)
      end

      def to_s
        @slicer.slice(@start, @length)
      end
    end
  end
end

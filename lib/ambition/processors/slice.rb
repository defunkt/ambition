module Ambition
  module Processors
    class Slice < Base
      def initialize(owner, start, length)
        @owner  = owner
        @start  = start
        @length = length
        @slicer = @owner.ambition_adapter::Slice.new
        @slicer.class.send(:attr_accessor, :owner)
        @slicer.owner = @owner
      end

      def to_s
        @slicer.slice(@start, @length)
      end
    end
  end
end

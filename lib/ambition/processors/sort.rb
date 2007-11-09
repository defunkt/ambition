module Ambition
  module Processors
    class Sort < Base
      def initialize(context, block)
        @context = context
        @block   = block
        @sorter  = new_api_instance
      end

      def process_call(args)
        if args.first.last == @receiver
          @sorter.by(*args[1..-1])

        # [[:call, [:dvar, :m], :age], :-@]
        elsif args.last == :-@
          @sorter.not_by(*args.first[2..-1])

        # sort_by(&:name).to_s
        # [[:call, [:dvar, :args], :shift], :__send__, [:argscat, [:array, [:self]], [:dvar, :args]]]
        elsif args[1] == :__send__
          @sorter.to_proc(value('to_s'))

        else
          raise args.inspect
        end
      end

      def process_vcall(args)
        @sorter.send(args.shift, *args)
      end

      def process_masgn(exp)
        ''
      end
    end
  end
end

module Ambition
  module Processors
    class Sort < Base
      def initialize(context, block)
        @context = context
        @block   = block
      end

      def process_call(args)
        if args.first.last == @receiver
          translator.sort_by(*args[1..-1])

        # sort_by { |m| -m.age }
        # [[:call, [:dvar, :m], :age], :-@]
        elsif args[0][1][-1] == @receiver && args.last == :-@
          translator.reverse_sort_by(*args.first[2..-1])

        # sort_by(&:name).to_s
        # [[:call, [:dvar, :args], :shift], :__send__, [:argscat, [:array, [:self]], [:dvar, :args]]]
        elsif args[1] == :__send__
          translator.to_proc(value('to_s'))

        # sort_by { |m| m.ideas.title } 
        # [[:call, [:dvar, :m], :ideas], :title]
        elsif args[0][1][-1] == @receiver
          first = args.first.last
          last  = args.last
          translator.chained_sort_by(first, last)

        # sort_by { |m| [ m.ideas.title, -m.invites.email ] } 
        # [[:call, [:call, [:dvar, :m], :invites], :email], :-@]
        elsif args[0][1][1][-1] == @receiver && args.last == :-@
          first = args.first[1].last
          last  = args.first.last
          translator.chained_reverse_sort_by(first, last)

        else
          raise args.inspect
        end
      end

      def process_vcall(args)
        translator.send(args.shift, *args)
      end

      def process_masgn(exp)
        ''
      end
    end
  end
end

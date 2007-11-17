module Ambition
  module Processors
    class Select < Base
      def initialize(context, block)
        @context  = context
        @block    = block
        @selector = new_api_instance
      end

      def process_call(args)
        # Operation (m.name == 'chris')
        #   [[:call, [:dvar, :m], :name], :==, [:array, [:str, "chris"]]]
        if args.size == 3
          left, operator, right = args

          # params are passed as an array, even when only one element:
          #  abc(1)
          #  => [:fcall, :abc, [:array, [:lit, 1]]
          #  abc([1])
          #  => [:fcall, :abc, [:array, [:array, [:lit, 1]]]]
          if right.first == :array 
            right = process(right)
            right = right.is_a?(Array) ? right.first : right
          else
            right = process(right)
          end

          @selector.send(process_operator(operator), process(left), right)

        # Property of passed arg:
        #   [[:dvar, :m], :name]
        elsif args.first.last == @receiver
          @selector.call(*args[1..-1])

        # Method call: 
        #   [[:call, [:dvar, :m], :name], :upcase]
        elsif args.first.first == :call && args.first[1].last == @receiver
          receiver, method = args
          @selector.chained_call(receiver.last, method)

        # Deep, chained call:
        #   [[:call, [:call, [:call, [:dvar, :m], :created_at], :something], :else], :perhaps]
        elsif args.flatten.include? @receiver
          calls = []

          until args.empty?
            args = args.last if args.last.is_a?(Array)
            break if args.last == @receiver
            calls << args.pop
          end

          @selector.chained_call(*calls.reverse)

        else
          raise args.inspect
        end
      end

      def process_match3(exp)
        right, left = exp
        process_call [ left, :=~, right ]
      end

      def process_and(exp)
        joined_expressions exp, :both
      end

      def process_or(exp)
        joined_expressions exp, :either
      end

      def joined_expressions(exp, with = nil)
        expressions = []

        while expression = exp.shift
          expressions << process(expression)
        end

        @selector.send(with, *expressions)
      end

      def process_not(args)
        negate { process(args.first) }
      end

      def process_operator(operator)
        @negated ? negate_operator(operator) : operator
      end

      def negate_operator(operator)
        case operator
        when :== then :not_equal
        when :=~ then :not_regexp
        else raise "Missing negated operator definition: #{operator}"
        end
      end

      def negate
        @negated = true
        yield
      ensure
        @negated = false
      end
    end
  end
end

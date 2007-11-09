module Ambition
  module Processors
    class Base
      ##
      # Processing methods
      def process_proc(exp)
        # puts "=> #{exp.inspect}"
        receiver, body = process(exp.shift), exp.shift
        process(body)
      end

      def process_dasgn_curr(exp)
        @receiver = exp.first
        @receiver.to_s
      end
      alias_method :process_dasgn, :process_dasgn_curr

      def process_array(exp)
        # Branch on whether this is straight Ruby or a real array
        if ruby = rubify(exp)
          ruby
        else
          exp.map { |m| process(m) }
        end
      end

      def process_str(exp)
        exp.first
      end

      def process_lit(exp)
        exp.first
      end

      def process_nil(exp)
        nil
      end

      def process_true(exp)
        true
      end

      def process_false(exp)
        false
      end

      def process_dvar(exp)
        target = exp.shift
        value(target.to_s[0..-1])
      end

      def process_ivar(exp)
        value(exp.shift.to_s[0..-1])
      end

      def process_lvar(exp)
        value(exp.shift.to_s)
      end

      def process_vcall(exp)
        value(exp.shift.to_s)
      end

      def process_gvar(exp)
        value(exp.shift.to_s)
      end
      
      def process(node)
        node ||= []

        if node.is_a? Symbol
          node
        elsif respond_to?(method = "process_#{node.first}") 
          send(method, node[1..-1]) 
        elsif node.blank?
          ''
        else
          raise "Missing process method for sexp: #{node.inspect}"
        end
      end

      ##
      # Helper methods
      def to_s
        process @block.to_sexp
      end

      def key
        self.class.name.split('::').last.downcase.intern
      end

      def value(variable)
        eval variable, @block
      end

      def new_api_instance
        self.class.new_api_instance(@context)
      end

      def self.new_api_instance(context, name = nil)
        name   ||= self.name.split('::').last
        klass    = context.owner.ambition_adapter.const_get(name)
        instance = klass.new

        unless instance.respond_to? :context
          klass.class_eval do
            attr_accessor :context
            def owner;    @context.owner   end
            def clauses;  @context.clauses end
            def stash;    @context.stash   end
          end
        end

        instance.context = context
        instance
      end

      def rubify(exp)
        # TODO: encapsulate this check in Ruby.should_process?(exp)
        if exp.first.first == :call && exp.first[1].last != @receiver && Array(exp.first[1][1]).last != @receiver
          value Ruby.process(exp.first)
        end
      end
    end
  end
end

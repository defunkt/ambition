module Ambition
  class RubyProcessor < RubyToRuby
    def self.process(node)
      @processor ||= new
      @processor.process node
    end

    ##
    # This is not DRY, and I don't care.
    def process(node)
      node ||= []

      if respond_to?(method = "process_#{node.first}") 
        send(method, node[1..-1]) 
      elsif node.blank?
        ''
      else
        raise "Missing process method for sexp: #{node.inspect}"
      end
    end
  end
end

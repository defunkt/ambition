require 'active_record/connection_adapters/abstract/quoting'
require 'ambition/proc_to_ruby'

module Ambition
  class Processor 
    include ActiveRecord::ConnectionAdapters::Quoting

    attr_reader :key, :join_string, :prefix, :includes

    def initialize
      @unsupported = [:alloca, :cfunc, :cref, :evstr, :ifunc, :last, :memo, :newline, :opt_n, :method] # internal nodes that you can't get to
      @includes = []
    end

    ##
    # Processing methods
    def process_proc(exp)
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
        value ruby
      else
        arrayed = exp.map { |m| process(m) }
        arrayed.join(', ')
      end
    end

    def rubify(exp)
      if exp.first.first == :call && exp.first[1].last != @receiver && Array(exp.first[1][1]).last != @receiver
        RubyProcessor.process(exp.first)
      end
    end

    ##
    # Helper methods
    def to_s
      process(@block.to_sexp).squeeze(' ')
    end

    def value(variable)
      sanitize eval(variable, @block)
    end

    def sanitize(value)
      if value.is_a? Array
        return value.map { |v| sanitize(v) }.join(', ')
      end

      case value
      when true,  'true'  
        '1'
      when false, 'false' 
        '0'
      when Regexp
        "'#{value.source}'"
      else 
        if active_connection?
          ActiveRecord::Base.connection.quote(value) 
        else
          quote(value)
        end
      end
    rescue
      "'#{value}'"
    end
    
    def quote_column_name(value)
      if active_connection?
        ActiveRecord::Base.connection.quote_column_name(value) 
      else
        value.to_s
      end
    end

    def active_connection?
      ActiveRecord::Base.active_connection_name
    end

    def statement(*args)
      @statement_instnace ||= DatabaseStatements.const_get(adapter_name).new
      @statement_instnace.send(*args)
    end

    def adapter_name
      ActiveRecord::Base.connection.adapter_name
    rescue ActiveRecord::ConnectionNotEstablished
      'Abstract'
    end

    def extract_includes(receiver, method)
      return unless receiver.first == :call && receiver[1].last == @receiver

      if reflection = @owner.reflections[receiver.last]
        @includes << reflection.name unless @includes.include? reflection.name
        "#{reflection.table_name}.#{method}"
      else
        raise "No reflection `#{receiver.last}' found on #{@owner}"
      end
    end

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

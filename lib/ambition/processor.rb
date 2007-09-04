require 'active_record/connection_adapters/abstract/quoting'

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
    def process_error(exp)
      raise "Missing process method for sexp: #{exp.inspect}"
    end

    def process_proc(exp)
      receiver, body = process(exp.shift), exp.shift
      return process(body)
    end

    def process_dasgn_curr(exp)
      @receiver = exp.shift
      return @receiver.to_s
    end

    def process_array(exp)
      arrayed = exp.map { |m| process(m) }
      exp.clear
      return arrayed.join(', ')
    end

    ##
    # Helper methods
    def to_s
      process(@block.to_sexp).squeeze(' ')
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
        ActiveRecord::Base.connection.quote(value) 
      end
    rescue ActiveRecord::ConnectionNotEstablished
      quote(value)
    rescue
      "'#{value}'"
    end
    
    def quote_column_name(value)
      ActiveRecord::Base.connection.quote_column_name(value) 
    rescue ActiveRecord::ConnectionNotEstablished
      value.to_s
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
      respond_to?(method = "process_#{node.shift}") ? send(method, node) : ''
    end
  end
end

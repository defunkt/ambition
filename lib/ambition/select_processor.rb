module Ambition
  class SelectProcessor < Processor 
    def initialize(owner, block)
      super()
      @receiver    = nil
      @owner       = owner
      @table_name  = owner.table_name
      @block       = block
      @key         = :conditions
    end

    ##
    # Sexp Processing Methods
    def process_and(exp)
      joined_expressions 'AND', exp
    end

    def process_or(exp)
      joined_expressions 'OR', exp
    end

    def process_not(exp)
      type, receiver, method, other = *exp.first

      case type
      when :call
        translation(receiver, negate(method, other), other)
      when :match3
        regexp = receiver.last
        "#{process(method)} #{statement(:negated_regexp, regexp)} #{sanitize(regexp)}"
      else
        process_error(exp)
      end
    end

    def process_call(exp)
      receiver, method, other = *exp

      translation(receiver, method, other)
    end

    def process_lit(exp)
      exp.shift.to_s
    end

    def process_str(exp)
      sanitize exp.shift
    end

    def process_nil(exp)
      'NULL'
    end

    def process_false(exp)
      sanitize 'false'
    end

    def process_true(exp)
      sanitize 'true'
    end

    def process_match3(exp)
      regexp, target = exp.shift.last, process(exp.shift)
      "#{target} #{statement(:regexp, regexp)} #{sanitize(regexp)}"
    end

    def process_dvar(exp)
      target = exp.shift
      if target == @receiver
        @table_name
      else
        value(target.to_s[0..-1])
      end
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

    def process_attrasgn(exp)
      raise "Assignment not supported.  Maybe you meant ==?"
    end

    ##
    #  Processor helper methods
    def joined_expressions(with, exp)
      clauses = []
      while clause = exp.shift
        clauses << clause
      end
      "(" + clauses.map { |c| process(c) }.join(" #{with} ") + ")"
    end

    def negate(method, target = nil)
      if Array(target).last == [:nil]
        return 'IS NOT'
      end

      case method
      when :== 
        '<>'
      when :=~
        '!~'
      else 
        raise "Not implemented: #{method.inspect}"
      end
    end
    
    def translation(receiver, method, other = nil)
      case method.to_s
      when 'IS NOT'
        "#{process(receiver)} IS NOT #{process(other)}"
      when '=='
        case other_value = process(other)
        when "NULL"
          "#{process(receiver)} IS #{other_value}"
        else
          "#{process(receiver)} = #{other_value}"
        end
      when '<>', '>', '<', '>=', '<='
        "#{process(receiver)} #{method} #{process(other)}"
      when 'include?'
        "#{process(other)} IN (#{process(receiver)})"
      when '=~'
        "#{process(receiver)} LIKE #{process(other)}"
      when '!~'
        "#{process(receiver)} NOT LIKE #{process(other)}"
      when 'upcase'
        "UPPER(#{process(receiver)})"
      when 'downcase'
        "LOWER(#{process(receiver)})"
      else
        extract_includes(receiver, method) || "#{process(receiver)}.#{quote_column_name(method)}"
      end
    end
  end
end

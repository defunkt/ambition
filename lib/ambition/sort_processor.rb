module Ambition
  class SortProcessor < Processor 
    def initialize(owner, block)
      super()
      @receiver    = nil
      @owner       = owner
      @table_name  = owner.table_name
      @block       = block
      @key         = :order
    end

    ##
    # Sexp Processing Methods
    def process_call(exp)
      receiver, method, other = *exp
      exp.clear

      translation(receiver, method, other)
    end

    def process_vcall(exp)
      if (method = exp.shift) == :rand
        'RAND()'
      else
        raise "Not implemented: :vcall for #{method}"
      end
    end

    def process_masgn(exp)
      exp.clear
      ''
    end

    ##
    # Helpers!
    def translation(receiver, method, other)
      case method
      when :-@
        "#{process(receiver)} DESC"
      when :__send__
        "#{@table_name}.#{eval('to_s', @block)}"
      else
        extract_includes(receiver, method) || "#{@table_name}.#{method}"
      end
    end
  end
end

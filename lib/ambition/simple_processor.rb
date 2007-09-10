module Ambition
  class SimpleProcessor 
    attr_reader  :key, :value
    alias_method :to_s, :value

    def initialize(info = {})
      @key, @value = info.to_a.first
    end
  end
end

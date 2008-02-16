require 'parse_tree'

module Ambition
  class SexpTranslator
    def self.translate(block)
      klass = Class.new { define_method(:proc_to_method, block) }
      body = ParseTree.translate(klass, :proc_to_method)[2][1..-1]
      [:proc, *body]
    end
  end
end

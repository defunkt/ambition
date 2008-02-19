require 'parse_tree'

module Ambition #:nodoc:
  class SexpTranslator
    @@block_cache = {}

    def self.translate(block)
      @@block_cache[block.to_s] ||= begin
        klass = Class.new { define_method(:proc_to_method, block) }
        body = ParseTree.translate(klass, :proc_to_method)[2][1..-1]
        [:proc, *body]
      end
    end
  end
end

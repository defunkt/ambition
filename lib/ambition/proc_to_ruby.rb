##
# Taken from ruby2ruby, Copyright (c) 2006 Ryan Davis under the MIT License
require 'parse_tree'
require 'ruby2ruby'

class ProcHolder
end

class Method
  def to_sexp
    ParseTree.translate(ProcHolder, :proc_to_method)
  end
end

class Proc
  def to_method
    ProcHolder.send(:define_method, :proc_to_method, self)
    ProcHolder.new.method(:proc_to_method)
  end

  def to_sexp
    body = to_method.to_sexp[2][1..-1]
    [:proc, *body]
  end
end

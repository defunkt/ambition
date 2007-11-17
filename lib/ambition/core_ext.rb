##
# Taken from ruby2ruby, Copyright (c) 2006 Ryan Davis under the MIT License
require 'parse_tree'
require 'ruby2ruby'

class Object
  def to_sexp
    instance_eval <<-end_eval
      return proc { #{inspect} }.to_sexp.last
    end_eval
  end

  def metaclass; (class << self; self end) end
  def meta_eval(&blk) metaclass.instance_eval(&blk) end
  def meta_def(name, &blk) meta_eval { define_method name, &blk } end
  def class_def(name, &blk) class_eval { define_method name, &blk } end
end

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

class Array
  def =~(array)
    struct_eql? array
  end
end

##
# This code lifted from http://eigenclass.org/hiki/Structural+equivalence+of+Ruby+objects
class Object
  def struct_object_id
    object_id
  end
  
  def immediate?
    [FalseClass, TrueClass, NilClass, Fixnum, Symbol].any?{|x| x === self}
  end
end

class Symbol
  def struct_eql?(other, *args)
    if [self, other].include? :X
      true
    elsif self == other
      true
    else
      false
    end
  end
end

class Array
  def struct_eql?(o, counter = [0], my_rec = {}, his_rec = {}, helper = {})
    return true if o == :X
    return true if o.struct_object_id == struct_object_id
    return false unless self.class === o
    return false if o.size != size
    
    counter[0] += 1
    my_rec[struct_object_id] = his_rec[o.struct_object_id] = counter[0]
    
    size.times do |i|
      x, y = self[i], o[i]
      if [x,y].any?{|object| object.immediate? }
        return false unless x.struct_eql?(y, counter, my_rec, his_rec, helper)
        next
      end
      xid, yid = x.struct_object_id, y.struct_object_id
      if Array === x and Array === y
        if my_rec[xid] || his_rec[yid]
          if my_rec[xid] != his_rec[yid]
            return false
          else # equal
            next
          end
        else
          return false unless x.struct_eql?(y, counter, my_rec, his_rec, helper)
        end
      elsif Array === x # y is not an array...
        return false
      else
        # general case
        return false unless x.struct_eql?(y, counter, my_rec, his_rec, helper)
      end
    end
    
    true
  end
end

class Object
  def struct_eql?(other, counter = [0], my_rec = {}, his_rec = {}, helper = {})
    return true if other == :X
    return true if other.struct_object_id == struct_object_id
    return false unless self.class === other
    return true if immediate?
    return false unless instance_variables.sort == other.instance_variables.sort
    
    counter[0] += 1
    my_rec[struct_object_id] = his_rec[other.struct_object_id] = counter[0]

    instance_variables.map do |iv|
      x, y = [self, other].map{|obj| obj.instance_variable_get(iv)}
      xid, yid = [x,y].map{|obj| obj.struct_object_id }
      xtag, ytag = my_rec[xid], his_rec[yid]
      if xtag || ytag
        if xtag == ytag
          next
        else
          return false
        end
      end

      counter[0] += 1
      my_rec[xid] = his_rec[yid] = counter[0]

      return false unless x.struct_eql?(y, counter, my_rec, his_rec, helper)
    end
    true
  end
end

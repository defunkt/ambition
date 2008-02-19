module Ambition #:nodoc:
  Enumerable = ::Enumerable.dup
  Enumerable.class_eval do
    remove_method :find, :find_all
  end
end

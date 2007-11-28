module Ambition
  Enumerable = ::Enumerable.dup
  Enumerable.class_eval do
    remove_method :find, :find_all
  end
end

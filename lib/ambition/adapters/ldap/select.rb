module Ambition
  module Adapters
    module LDAP
      class Select < Base
        def call(*methods)
        end

        def both(left, right)
        end

        def either(left, right)
        end

        def ==(left, right)
        end

        # !=
        def not_equal(left, right)
        end

        def =~(left, right)
        end

        # !~
        def not_regexp(left, right)
        end

        def <(left, right)
        end

        def >(left, right)
        end

        def >=(left, right)
        end

        def <=(left, right)
        end

        def include?(left, right)
        end
      end
    end
  end
end

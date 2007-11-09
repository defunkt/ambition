module Ambition
  module Adapters
    module LDAP
      class Select < Base
        def call(*methods)
          method = methods.first.to_s
          if method[-1] == ??
            "(#{method[0...-1]}=#{sanitize true})"
          else
            method
          end
        end

        def chained_call(*methods)
          call(*methods)
        end

        def both(left, right)
          "(&#{left}#{sanitize right})"
        end

        def either(left, right)
          "(|#{left}#{sanitize right})"
        end

        def ==(left, right)
          "(#{left}=#{sanitize right})"
        end

        # !=
        def not_equal(left, right)
          "(!(#{left}=#{sanitize right}))"
        end

        def =~(left, right)
        end

        # !~
        def not_regexp(left, right)
        end

        def <(left, right)
          self.<=(left, right)
        end

        def >(left, right)
          self.>=(left, right)
        end

        def >=(left, right)
          "(#{left}>=#{sanitize right})"
        end

        def <=(left, right)
          "(#{left}<=#{sanitize right})"
        end

        def include?(left, right)
          bits = left.map { |item| "(#{right}=#{item})" }
          "(|#{bits})"
        end
      end
    end
  end
end

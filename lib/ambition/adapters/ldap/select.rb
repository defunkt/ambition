module Ambition
  module Adapters
    module LDAP
      class Select < Base
        def call(method, *args)
          if method.to_s[-1] == ??
            "(#{method.to_s[0...-1]}=#{sanitize true})"
          else
            method
          end
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

      private
        def sanitize(object)
          case object
          when true  then 'TRUE'
          when false then 'FALSE'
          else object.to_s
          end
        end
      end
    end
  end
end

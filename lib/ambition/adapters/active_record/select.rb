module Ambition
  module Adapters
    module ActiveRecord
      class Select < Base
        def call(method)
          "#{owner.table_name}.#{quote_column_name method}"
        end

        def chained_call(*methods)
          if reflection = owner.reflections[methods.first]
            "#{reflection.table_name}.#{quote_column_name methods.last}"
          else 
            send(methods[1], methods.first)
          end
        end

        def both(left, right)
          "(#{left} AND #{right})"
        end

        def either(left, right)
          "(#{left} OR #{right})"
        end

        def ==(left, right)
          if right.nil?
            "#{left} IS NULL"
          else
            "#{left} = #{sanitize right}"
          end
        end

        # !=
        def not_equal(left, right)
          if right.nil?
            "#{left} IS NOT NULL"
          else
            "#{left} <> #{sanitize right}"
          end
        end

        def =~(left, right)
          if right.is_a? Regexp
            "#{left} #{statement(:regexp, right)} #{sanitize right}"
          else
            "#{left} LIKE #{sanitize right}"
          end
        end

        # !~
        def not_regexp(left, right)
          if right.is_a? Regexp
            "#{left} #{statement(:not_regexp, right)} #{sanitize right}"
          else
            "#{left} NOT LIKE #{sanitize right}"
          end
        end

        def <(left, right)
          "#{left} < #{sanitize right}"
        end

        def >(left, right)
          "#{left} > #{sanitize right}"
        end

        def >=(left, right)
          "#{left} >= #{sanitize right}"
        end

        def <=(left, right)
          "#{left} <= #{sanitize right}"
        end

        def include?(left, right)
          left = left.map { |element| sanitize element }.join(', ')
          "#{right} IN (#{left})"
        end

        def downcase(column)
          "LOWER(#{owner.table_name}.#{quote_column_name column})"
        end

        def upcase(column)
          "UPPER(#{owner.table_name}.#{quote_column_name column})"
        end
      end
    end
  end
end

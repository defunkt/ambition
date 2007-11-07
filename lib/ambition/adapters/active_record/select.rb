module Ambition
  module Adapters
    module ActiveRecord
      class Select < Base
        def call(*methods)
          "#{owner.table_name}.#{quote_column_name methods.first}"
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

      private
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

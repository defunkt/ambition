module Ambition
  module Adapters
    module ActiveRecord
      class Sort < Base
        def sort_by(method)
          "#{owner.table_name}.#{quote_column_name method}" 
        end

        def reverse_sort_by(method)
          "#{owner.table_name}.#{quote_column_name method} DESC" 
        end

        def chained_sort_by(receiver, method)
          if reflection = owner.reflections[receiver]
            stash[:include] ||= []
            stash[:include] << receiver
            "#{reflection.table_name}.#{quote_column_name method}"
          else 
            raise [ receiver, method ].inspect
          end
        end

        def chained_reverse_sort_by(receiver, method)
          if reflection = owner.reflections[receiver]
            stash[:include] ||= []
            stash[:include] << receiver
            "#{reflection.table_name}.#{quote_column_name method} DESC"
          else 
            raise [ receiver, method ].inspect
          end
        end

        def to_proc(symbol)
          "#{owner.table_name}.#{symbol}"
        end

        def rand
          'RAND()'
        end
      end
    end
  end
end

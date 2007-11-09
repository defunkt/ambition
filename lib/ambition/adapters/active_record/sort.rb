module Ambition
  module Adapters
    module ActiveRecord
      class Sort < Base
        def by(*args)
          args.map { |arg| "#{owner.table_name}.#{quote_column_name arg}" }
        end

        def not_by(*args)
          args.map { |arg| "#{owner.table_name}.#{quote_column_name arg} DESC" }
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

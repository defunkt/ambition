require 'active_record/connection_adapters/abstract/quoting'

module Ambition
  module Adapters
    module ActiveRecord
      class Base
        include ::ActiveRecord::ConnectionAdapters::Quoting

        def sanitize(value)
          if value.is_a? Array
            return value.map { |v| sanitize(v) }.join(', ')
          end

          case value
          when true,  'true'  
            '1'
          when false, 'false' 
            '0'
          when Regexp
            "'#{value.source}'"
          else 
            if active_connection?
              ::ActiveRecord::Base.connection.quote(value) 
            else
              quote(value)
            end
          end
        rescue
          "'#{value}'"
        end

        def quote_column_name(value)
          if active_connection?
            ::ActiveRecord::Base.connection.quote_column_name(value) 
          else
            value.to_s
          end
        end

        def active_connection?
          ::ActiveRecord::Base.active_connection_name
        end

        def dbadapter_name
          ::ActiveRecord::Base.connection.adapter_name
        rescue ::ActiveRecord::ConnectionNotEstablished
          'Abstract'
        end

        def statement(*args)
          @statement_instance ||= DatabaseStatements.const_get(dbadapter_name).new
          @statement_instance.send(*args)
        end
      end
    end
  end
end

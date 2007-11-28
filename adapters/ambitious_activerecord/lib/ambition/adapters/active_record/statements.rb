module Ambition
  module Adapters
    module ActiveRecord
      module DatabaseStatements
        def self.const_missing(*args)
          Abstract
        end

        class Abstract
          def regexp(regexp)
            'REGEXP'
          end

          def not_regexp(regexp)
            'NOT REGEXP'
          end
        end

        class PostgreSQL < Abstract
          def regexp(regexp)
            if regexp.options == 1
              '~*'
            else
              '~'
            end
          end

          def not_regexp(regexp)
            if regexp.options == 1
              '!~*'
            else
              '!~'
            end
          end
        end
      end
    end
  end
end

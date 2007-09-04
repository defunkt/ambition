module Ambition
  module DatabaseStatements
    def self.const_missing(*args)
      Abstract
    end

    class Abstract
      def regexp(options)
        'REGEXP'
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

      def negated_regexp(regexp)
        if regexp.options == 1
          '!~*'
        else
          '!~'
        end
      end
    end
  end
end

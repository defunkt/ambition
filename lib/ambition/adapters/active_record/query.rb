module Ambition
  module Adapters
    module ActiveRecord
      class Query
        @@select = 'SELECT * FROM %s %s'

        def initialize(context)
          @context = context
        end

        def clauses
          @context.clauses
        end

        def kick
          @context.owner.find(:all, to_hash)
        end

        def size
          @context.owner.count(to_hash)
        end

        def to_hash
          hash = {}

          unless (where = clauses[:select]).blank?
            hash[:conditions] = Array(where)
            hash[:conditions] *= ' AND '
          end

          unless (includes = clauses[:includes]).blank?
            hash[:include] = includes.flatten
          end

          if order = clauses[:sort]
            hash[:order] = order.join(', ')
          end

          if clauses[:slice].last =~ /LIMIT (\d+)/
            hash[:limit] = $1.to_i
          end

          if clauses[:slice].last =~ /OFFSET (\d+)/
            hash[:offset] = $1.to_i
          end

          hash[:include] = @context[:include] if @context[:include]

          hash
        end

        def to_s
          hash = to_hash

          raise "Sorry, I can't construct SQL with complex joins (yet)" unless hash[:includes].blank?

          sql = []
          sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].blank?
          sql << "ORDER BY #{hash[:order]}"   unless hash[:order].blank?
          sql << clauses[:slice]              unless hash[:slice].blank?

          @@select % [ @context.owner.table_name, sql.join(' ') ]
        end
        alias_method :to_sql, :to_s
      end
    end
  end
end

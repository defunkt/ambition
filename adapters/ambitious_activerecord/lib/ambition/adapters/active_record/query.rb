module Ambition
  module Adapters
    module ActiveRecord
      class Query
        @@select = 'SELECT * FROM %s %s'

        def kick
          owner.find(:all, to_hash)
        end

        def size
          owner.count(to_hash)
        end

        def to_hash
          hash = {}

          unless (where = clauses[:select]).blank?
            hash[:conditions] = Array(where)
            hash[:conditions] *= ' AND '
          end

          if order = clauses[:sort]
            hash[:order] = order.join(', ')
          end

          if Array(clauses[:slice]).last =~ /LIMIT (\d+)/
            hash[:limit] = $1.to_i
          end

          if Array(clauses[:slice]).last =~ /OFFSET (\d+)/
            hash[:offset] = $1.to_i
          end

          hash[:include] = stash[:include] if stash[:include]

          hash
        end

        def to_s
          hash = to_hash

          raise "Sorry, I can't construct SQL with complex joins (yet)" unless hash[:include].blank?

          sql = []
          sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].blank?
          sql << "ORDER BY #{hash[:order]}"   unless hash[:order].blank?
          sql << clauses[:slice].last         unless hash[:slice].blank?

          @@select % [ owner.table_name, sql.join(' ') ]
        end
        alias_method :to_sql, :to_s
      end
    end
  end
end

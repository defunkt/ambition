require File.dirname(__FILE__) + '/../../helper'

module ActiveLdap
  class Base
  end
end

module ActiveLdap
  module Operations
    def self.included(base)
      super
      base.class_eval do
        # ...
        extend(Find)
        # ...
        include(Find)
        # ...
      end
    end
    module Find
      def find(*args)
        "dummy find method"
      end
    end
  end
end

ActiveLdap::Base.class_eval do
# ...
  include ActiveLdap::Operations
# ...
end


class LDAPUser < ActiveLdap::Base
  def self.table_name
    # in real life would call the base class method on the ActiveLdap model class
    'ou=people,dc=automatthew,dc=com'
  end
end

require 'ambition/adapters/ldap'

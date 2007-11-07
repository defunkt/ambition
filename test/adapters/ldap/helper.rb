require File.dirname(__FILE__) + '/../../helper'

module ActiveLdap
  class Base
    def find(*args)
      "dummy find method"
    end
  end
end


class LDAPUser < ActiveLdap::Base
  def self.table_name
    # in real life would call the base class method on the ActiveLdap model class
    'ou=people,dc=automatthew,dc=com'
  end
end

require 'ambition/adapters/ldap'

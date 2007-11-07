require File.dirname(__FILE__) + '/../../helper'

module LDAP
  class Base
  end
end


class LDAPUser < LDAP::Base
  def self.table_name
    # in real life would call the base class method on the ActiveLDAP model class
    'ou=people,dc=automatthew,dc=com'
  end
end

require 'ambition/adapters/ldap'

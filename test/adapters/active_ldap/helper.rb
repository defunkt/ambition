require File.dirname(__FILE__) + '/../../helper'

require 'ambition/adapters/active_ldap'

ActiveLdap::Base.class_eval do
  def self.find(*args)
    'dummy find method'
  end
end

class LDAPUser < ActiveLdap::Base
  def self.table_name
    # in real life would call the base class method on the ActiveLdap model class
    'ou=people,dc=automatthew,dc=com'
  end
end

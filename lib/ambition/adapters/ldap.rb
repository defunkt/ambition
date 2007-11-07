require 'ambition/adapters/ldap/query'
require 'ambition/adapters/ldap/base'
require 'ambition/adapters/ldap/select'

LDAP::Base.extend Ambition::API
LDAP::Base.ambition_adapter = Ambition::Adapters::LDAP

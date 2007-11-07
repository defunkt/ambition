require 'ambition/adapters/ldap/query'
require 'ambition/adapters/ldap/base'
require 'ambition/adapters/ldap/select'

ActiveLdap::Base.extend Ambition::API
ActiveLdap::Base.ambition_adapter = Ambition::Adapters::LDAP

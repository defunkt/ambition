require 'ambition'
require 'active_ldap'
require 'ambition/adapters/active_ldap/query'
require 'ambition/adapters/active_ldap/base'
require 'ambition/adapters/active_ldap/select'

ActiveLdap::Base.extend Ambition::API
ActiveLdap::Base.ambition_adapter = Ambition::Adapters::ActiveLdap

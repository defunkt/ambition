require 'ambition'
require 'active_record'
require 'ambition/adapters/active_record/query'
require 'ambition/adapters/active_record/base'
require 'ambition/adapters/active_record/select'
require 'ambition/adapters/active_record/sort'
require 'ambition/adapters/active_record/slice'
require 'ambition/adapters/active_record/statements'

ActiveRecord::Base.extend Ambition::API
ActiveRecord::Base.ambition_adapter = Ambition::Adapters::ActiveRecord

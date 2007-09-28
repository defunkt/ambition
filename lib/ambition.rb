unless defined? ActiveRecord
  require 'rubygems'
  require 'active_record' 
end
require 'ambition/api'
require 'ambition/source'
require 'ambition/processor'
require 'ambition/ruby_processor'
require 'ambition/select_processor'
require 'ambition/sort_processor'
require 'ambition/simple_processor'
require 'ambition/query'
require 'ambition/database_statements'

ActiveRecord::Base.extend Ambition::API

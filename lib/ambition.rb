unless defined? ActiveRecord
  require 'rubygems'
  require 'active_record' 
end
require 'ambition/proc_to_ruby'
require 'ambition/processor'
require 'ambition/query'
require 'ambition/where'
require 'ambition/order'
require 'ambition/limit'
require 'ambition/count'
require 'ambition/enumerable'
require 'ambition/database_statements'

module Ambition 
  include Where, Order, Limit, Enumerable, Count

  attr_accessor :query_context

  def query_context
    @query_context || Query.new(self)
  end
end

ActiveRecord::Base.extend Ambition

require 'rubygems'
begin
  require 'test/spec' unless $NO_TEST
  require 'mocha'
rescue LoadError
  puts "=> You need the test-spec and mocha gems to run these tests."
  exit
end
require 'active_support'
require 'active_record'

begin require 'redgreen'; rescue LoadError; end unless $NO_TEST

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'ambition'

class User < ActiveRecord::Base 
  def self.reflections
    return @reflections if @reflections
    @reflections = {}
    @reflections[:ideas]    = Reflection.new(:has_many,   'user_id',     :ideas,   'ideas')
    @reflections[:invites]  = Reflection.new(:has_many,   'referrer_id', :invites, 'invites')
    @reflections[:profile]  = Reflection.new(:has_one,    'user_id',     :profile, 'profiles')
    @reflections[:account]  = Reflection.new(:belongs_to, 'account_id',  :account, 'accounts')
    @reflections
  end

  def self.table_name
    'users'
  end
end

class Reflection < Struct.new(:macro, :primary_key_name, :name, :table_name)
end

module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter  
      def connect(*args)
        true
      end
    end

    class PostgreSQLAdapter  
      def connect(*args)
        true
      end
      class PGError; end
    end

    class FakeAdapter < AbstractAdapter
    end
  end
end

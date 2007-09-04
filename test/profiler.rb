$:.unshift File.dirname(__FILE__) + '/../lib'
require 'ambition'
require 'ruby-prof'

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

result = RubyProf.profile do
  1000.times do
    User.select { |u| (u.id == 20 && u.age > 20) || u.profile.name == 'Jon' }.sort_by { |u| [u.id, -u.name] }.first(20).to_hash
  end
end

printer = RubyProf::FlatPrinter.new(result)
#printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, 0) 

puts User.select { |u| (u.id == 20 && u.age > 20) || u.profile.name == 'Jon' }.sort_by { |u| [u.id, -u.name] }.first(20).to_hash.inspect

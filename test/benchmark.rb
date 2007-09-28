$:.unshift File.dirname(__FILE__) + '/../lib'
$NO_TEST = true
%w( ambition rubygems active_record benchmark ).each { |f| require f }

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

Times = 1000

Benchmark.bm(30) do |x|
  x.report 'simple select' do
    Times.times do
      User.select { |u| u.id == 20 }.to_hash
    end
  end

  x.report 'simple select w/ eval' do
    Times.times do
      User.select { |u| u.created_at == Time.now }.to_hash
    end
  end

  x.report 'dual select' do
    Times.times do
      User.select { |u| u.id == 20 && u.age > 20 }.to_hash
    end
  end

  x.report 'join select' do
    Times.times do
      User.select { |u| u.id == 20 && u.ideas.name =~ /stuff/ }.to_hash
    end
  end

  x.report 'dual select w/ sort' do
    Times.times do
      User.select { |u| u.id == 20 && u.age > 20 }.sort_by { |u| u.id }.to_hash
    end
  end

  x.report 'dual select w/ sort & first' do
    Times.times do
      User.select { |u| u.id == 20 && u.age > 20 }.sort_by { |u| u.id }.first(20).to_hash
    end
  end

  x.report "it's complicated" do
    Times.times do
      User.select { |u| (u.id == 20 && u.age > 20) || u.profile.name == 'Jon' }.sort_by { |u| [u.id, -u.name] }.first(20).to_hash
    end
  end
end

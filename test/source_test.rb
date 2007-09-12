require File.dirname(__FILE__) + '/helper'
require 'ostruct' 

context "Setting the ambition_source" do
  setup do
    @users = [
      OpenStruct.new(:name => 'Chris', :age => 22),
      OpenStruct.new(:name => 'PJ',    :age => 24),
      OpenStruct.new(:name => 'Kevin', :age => 23),
      OpenStruct.new(:name => '_why',  :age => 65)
    ]
    User.ambition_source = @users
  end

  teardown do
    User.ambition_source = nil
  end

  specify "should run all selects /  detects against that collection" do
    User.detect { |u| u.name == 'Chris' }.should == @users.first
  end

  specify "should run all sorts against that collection" do
    User.sort_by { |u| -u.age }.entries.should == @users.sort_by { |u| -u.age }
  end

  specify "should chain successfully" do
    User.select { |u| u.age > 22 }.sort_by { |u| -u.age }.entries.should == [ @users[3], @users[1], @users[2] ]
  end

  specify "should be able to revert to normal" do
    block = proc { User.select { |m| m.name == 'PJ' }.first }

    User.expects(:find).never
    block.call.should == @users[1]

    conditions = { :conditions => "users.name = 'PJ'", :limit => 1 }
    User.expects(:find).with(:first, conditions)

    User.ambition_source = nil
    block.call
  end
end

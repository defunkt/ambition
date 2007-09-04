require File.dirname(__FILE__) + '/helper'

context "Limit" do
  setup do
    @sql = User.select { |m| m.name == 'jon' }
  end

  specify "first" do
    conditions = { :conditions => "users.name = 'jon'", :limit => 1 }
    User.expects(:find).with(:first, conditions)
    @sql.first
  end

  specify "first with argument" do
    conditions = { :conditions => "users.name = 'jon'", :limit => 5 }
    User.expects(:find).with(:all, conditions)
    @sql.first(5).entries
  end
  
  specify "[] with two elements" do
    conditions = { :conditions => "users.name = 'jon'", :limit => 20, :offset => 10 }
    User.expects(:find).with(:all, conditions)
    @sql[10, 20].entries

    conditions = { :conditions => "users.name = 'jon'", :limit => 20, :offset => 20 }
    User.expects(:find).with(:all, conditions)
    @sql[20, 20].entries
  end
  
  specify "slice is an alias of []" do
    conditions = { :conditions => "users.name = 'jon'", :limit => 20, :offset => 10 }
    User.expects(:find).with(:all, conditions)
    @sql.slice(10, 20).entries
  end
  
  specify "[] with range" do
    conditions = { :conditions => "users.name = 'jon'", :limit => 10, :offset => 10 }
    User.expects(:find).with(:all, conditions)
    @sql[10..20].entries
  end
end

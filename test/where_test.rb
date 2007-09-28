require File.dirname(__FILE__) + '/helper'

context "Where (using select)" do
  specify "simple ==" do
    sql = User.select { |m| m.name == 'jon' }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = 'jon'"
  end

  specify "simple !=" do
    sql = User.select { |m| m.name != 'jon' }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name <> 'jon'"
  end

  specify "simple == && ==" do
    sql = User.select { |m| m.name == 'jon' && m.age == 21 }.to_sql
    sql.should == "SELECT * FROM users WHERE (users.name = 'jon' AND users.age = 21)"
  end

  specify "simple == || ==" do
    sql = User.select { |m| m.name == 'jon' || m.age == 21 }.to_sql
    sql.should == "SELECT * FROM users WHERE (users.name = 'jon' OR users.age = 21)"
  end

  specify "mixed && and ||" do
    sql = User.select { |m| m.name == 'jon' || m.age == 21 && m.password == 'pass' }.to_sql
    sql.should == "SELECT * FROM users WHERE (users.name = 'jon' OR (users.age = 21 AND users.password = 'pass'))"
  end

  specify "grouped && and ||" do
    sql = User.select { |m| (m.name == 'jon' || m.name == 'rick') && m.age == 21 }.to_sql
    sql.should == "SELECT * FROM users WHERE ((users.name = 'jon' OR users.name = 'rick') AND users.age = 21)"
  end

  specify "simple >/<" do
    sql = User.select { |m| m.age > 21 }.to_sql
    sql.should == "SELECT * FROM users WHERE users.age > 21"

    sql = User.select { |m| m.age >= 21 }.to_sql
    sql.should == "SELECT * FROM users WHERE users.age >= 21"

    sql = User.select { |m| m.age < 21 }.to_sql
    sql.should == "SELECT * FROM users WHERE users.age < 21"
  end

  specify "array.include? item" do
    sql = User.select { |m| [1, 2, 3, 4].include? m.id }.to_sql
    sql.should == "SELECT * FROM users WHERE users.id IN (1, 2, 3, 4)"
  end

  specify "variable'd array.include? item" do
    array = [1, 2, 3, 4]
    sql = User.select { |m| array.include? m.id }.to_sql
    sql.should == "SELECT * FROM users WHERE users.id IN (1, 2, 3, 4)"
  end

  specify "simple == with variables" do
    me = 'chris'
    sql = User.select { |m| m.name == me }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = '#{me}'"
  end

  specify "simple == with method arguments" do
    def test_it(name)
      sql = User.select { |m| m.name == name }.to_sql
      sql.should == "SELECT * FROM users WHERE users.name = '#{name}'"
    end

    test_it('chris')
  end

  specify "simple == with instance variables" do
    @me = 'chris'
    sql = User.select { |m| m.name == @me }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = '#{@me}'"
  end

  specify "simple == with instance variable method call" do
    require 'ostruct'
    @person = OpenStruct.new(:name => 'chris')

    sql = User.select { |m| m.name == @person.name }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = '#{@person.name}'"
  end

  specify "simple == with global variables" do
    $my_name = 'boston'
    sql = User.select { |m| m.name == $my_name }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = '#{$my_name}'"
  end

  specify "simple == with method call" do
    def band
      'megadeth'
    end

    sql = User.select { |m| m.name == band }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = '#{band}'"
  end

  specify "simple =~ with string" do
    sql = User.select { |m| m.name =~ 'chris' }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name LIKE 'chris'"

    sql = User.select { |m| m.name =~ 'chri%' }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name LIKE 'chri%'"
  end

  specify "simple !~ with string" do
    sql = User.select { |m| m.name !~ 'chris' }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name NOT LIKE 'chris'"

    sql = User.select { |m| !(m.name =~ 'chris') }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name NOT LIKE 'chris'"
  end

  specify "simple =~ with regexp" do
    sql = User.select { |m| m.name =~ /chris/ }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name REGEXP 'chris'"
  end

  specify "simple =~ with regexp flags" do
    sql = User.select { |m| m.name =~ /chris/i }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name REGEXP 'chris'"
  end

  specify "simple LOWER()" do
    sql = User.select { |m| m.name.downcase =~ 'chris%' }.to_sql
    sql.should == "SELECT * FROM users WHERE LOWER(users.name) LIKE 'chris%'"
  end

  specify "simple UPPER()" do
    sql = User.select { |m| m.name.upcase =~ 'chris%' }.to_sql
    sql.should == "SELECT * FROM users WHERE UPPER(users.name) LIKE 'chris%'"
  end

  specify "undefined equality symbol" do
    should.raise { User.select { |m| m.name =* /chris/ }.to_sql }
  end

  specify "block variable / assigning variable conflict" do
    m = User.select { |m| m.name == 'chris' }.to_sql
    m.should == "SELECT * FROM users WHERE users.name = 'chris'"
  end
  
  specify "simple == with inline ruby" do
    sql = User.select { |m| m.created_at == 2.days.ago.to_s(:db) }.to_sql
    sql.should == "SELECT * FROM users WHERE users.created_at = '#{2.days.ago.to_s(:db)}'"
  end

  specify "inspect" do
    User.select { |u| u.name }.inspect.should.match %r(call #to_sql or #to_hash)
  end
end

context "Where (using detect)" do
  specify "simple ==" do
    User.expects(:select).returns(mock(:first => true))
    User.detect { |m| m.name == 'chris' }
  end

  specify "nothing found" do
    User.expects(:select).returns(mock(:first => nil))
    User.detect { |m| m.name == 'chris' }.should.be.nil
  end
end

context "Where (using [])" do
  specify "finds a single row" do
    User.expects(:find).with(1)
    User[1]
  end
end

context "PostgreSQL specific"  do
  setup do
    ActiveRecord::Base.connection = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.new 'fake_connection', 'fake_logger'
  end

  teardown do
    ActiveRecord::Base.remove_connection
  end

  specify "quoting of column name" do
    me = 'chris'
    sql = User.select { |m| m.name == me }.to_sql
    sql.should == %(SELECT * FROM users WHERE users."name" = '#{me}')
  end

  specify "simple =~ with regexp" do
    sql = User.select { |m| m.name =~ /chris/ }.to_sql
    sql.should == %(SELECT * FROM users WHERE users."name" ~ 'chris')
  end

  specify "insensitive =~" do
    sql = User.select { |m| m.name =~ /chris/i }.to_sql
    sql.should == %(SELECT * FROM users WHERE users."name" ~* 'chris')
  end

  specify "negated =~" do
    sql = User.select { |m| m.name !~ /chris/ }.to_sql
    sql.should == %(SELECT * FROM users WHERE users."name" !~ 'chris')
  end

  specify "negated insensitive =~" do
    sql = User.select { |m| m.name !~ /chris/i }.to_sql
    sql.should == %(SELECT * FROM users WHERE users."name" !~* 'chris')
  end
end

context "MySQL specific" do
  setup do
    ActiveRecord::Base.connection = ActiveRecord::ConnectionAdapters::MysqlAdapter.new('connection', 'logger', 'options', 'config')
  end

  teardown do
    ActiveRecord::Base.remove_connection
  end

  specify "quoting of column name" do
    me = 'chris'
    sql = User.select { |m| m.name == me }.to_sql
    sql.should == "SELECT * FROM users WHERE users.`name` = '#{me}'"
  end

  specify "simple =~ with regexp" do
    sql = User.select { |m| m.name =~ /chris/ }.to_sql
    sql.should == "SELECT * FROM users WHERE users.`name` REGEXP 'chris'"
  end
end

context "Adapter without overrides" do
  setup do
    ActiveRecord::Base.connection = ActiveRecord::ConnectionAdapters::FakeAdapter.new('connection', 'logger')
  end

  teardown do
    ActiveRecord::Base.remove_connection
  end

  specify "quoting of column name" do
    me = 'chris'
    sql = User.select { |m| m.name == me }.to_sql
    sql.should == "SELECT * FROM users WHERE users.name = '#{me}'"
  end
end

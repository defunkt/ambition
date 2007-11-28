require File.dirname(__FILE__) + '/helper'

context "Each" do
  specify "simple ==" do
    hash = { :filter => "(uid=mking)" }
    LDAPUser.expects(:find).with(:all, hash).returns([])
    LDAPUser.select { |m| m.uid == 'mking' }.each do |user|
      puts user.cn
    end
  end

  xspecify "limit and conditions" do
    hash = { :limit => 5, :filter => "(uid=mking)" }
        LDAPUser.expects(:find).with(:all, hash).returns([])
        LDAPUser.select { |m| m.uid == 'mking' }.first(5).each do |user|
          puts user.cn
        end
  end

  xspecify "limit and conditions and order" do
    hash = { :limit => 5, :filter => "(uid=mking)", :sort_by => 'sn' }
    LDAPUser.expects(:find).with(:all, hash).returns([])
    LDAPUser.select { |m| m.uid == 'mking' }.sort_by { |m| m.sn }.first(5).each do |user|
      puts user.cn
    end
  end

  xspecify "limit and order" do
    hash = { :limit => 5, :sort_by => 'sn' }
    LDAPUser.expects(:find).with(:all, hash).returns([])
    LDAPUser.sort_by { |m| m.sn }.first(5).each do |user|
      puts user.name
    end
  end
end

context "Enumerable Methods" do
  specify "map" do
    hash = { :filter => "(uid=mking)" }
    LDAPUser.expects(:find).with(:all, hash).returns([])
    LDAPUser.select { |m| m.uid == 'mking' }.map { |u| u.name }
  end

  specify "each_with_index" do
    hash = { :filter => "(uid=mking)" }
    LDAPUser.expects(:find).with(:all, hash).returns([])
    LDAPUser.select { |m| m.uid == 'mking' }.each_with_index do |user, i|
      puts "#{i}: #{user.name}"
    end
  end

  # specify "any?" do
  #   LDAPUser.expects(:count).with(:conditions => "users.age > 21").returns(1)
  #   LDAPUser.any? { |u| u.age > 21 }.should == true
  # end

#   specify "all?" do
#     LDAPUser.expects(:count).at_least_once.returns(10, 20)
#     LDAPUser.all? { |u| u.age > 21 }.should == false
# 
#     LDAPUser.expects(:count).at_least_once.returns(10, 10)
#     LDAPUser.all? { |u| u.age > 21 }.should == true
#   end
# 
#   specify "empty?" do
#     LDAPUser.expects(:count).with(:conditions => "users.age > 21").returns(1)
#     LDAPUser.select { |u| u.age > 21 }.empty?.should.equal false
# 
#     LDAPUser.expects(:count).with(:conditions => "users.age > 21").returns(0)
#     LDAPUser.select { |u| u.age > 21 }.empty?.should.equal true
#   end
# 
  specify "entries" do
    LDAPUser.expects(:find).with(:all, {})
    LDAPUser.entries

    hash = { :filter => "(uid=mking)" }
    LDAPUser.expects(:find).with(:all, hash).returns([])
    LDAPUser.select { |m| m.uid == 'mking' }.entries
  end

  specify "to_a" do
    LDAPUser.expects(:find).with(:all, {})
    LDAPUser.to_a
  end
# 
#   xspecify "each_slice" do
#   end
# 
#   xspecify "max" do
#   end
# 
#   xspecify "min" do
#   end
end

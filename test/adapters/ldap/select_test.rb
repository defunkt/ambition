require File.dirname(__FILE__) + '/helper'

context "Filter (using select)" do
  
  specify "simple ==" do
    filter = LDAPUser.select { |m| m.name == 'jon' }.to_s
    filter.should == "(name=jon)"
  end
  
  specify "simple !=" do
    filter = LDAPUser.select { |m| m.name != 'jon' }.to_s
    filter.should == "(!(name=jon))"
  end

  specify "simple == && ==" do
    filter = LDAPUser.select { |m| m.name == 'jon' && m.age == 21 }.to_s
    filter.should == "(&(name=jon)(age=21))"
  end

  specify "simple == || ==" do
    filter = LDAPUser.select { |m| m.name == 'jon' || m.age == 21 }.to_s
    filter.should == "(|(name=jon)(age=21))"
  end
  
  specify "mixed && and ||" do
    filter = LDAPUser.select { |m| m.name == 'jon' || m.age == 21 && m.password == 'pass' }.to_s
    filter.should == "(|(name=jon)(&(age=21)(password=pass)))"
  end

  specify "grouped && and ||" do
    filter = LDAPUser.select { |m| (m.name == 'jon' || m.name == 'rick') && m.age == 21 }.to_s
    filter.should == "(&(|(name=jon)(name=rick))(age=21))"
  end
  
  specify "simple >/<" do
    # LDAP apparently only supports >= and <=
    filter = LDAPUser.select { |m| m.age > 21 }.to_s
    filter.should == "(age>=21)"

    filter = LDAPUser.select { |m| m.age >= 21 }.to_s
    filter.should == "(age>=21)"

    filter = LDAPUser.select { |m| m.age < 21 }.to_s
    filter.should == "(age<=21)"
    
    filter = LDAPUser.select { |m| m.age <= 21 }.to_s
    filter.should == "(age<=21)"
  end
  
  
  specify "array.include? item" do
    filter = LDAPUser.select { |m| [1, 2, 3, 4].include? m.id }.to_s
    # I'm not sure whether this is idiomatic, but it works.
    filter.should == "(|(id=1)(id=2)(id=3)(id=4))"
  end

  specify "variable'd array.include? item" do
    array = [1, 2, 3, 4]
    filter = LDAPUser.select { |m| array.include? m.id }.to_s
    filter.should == "(|(id=1)(id=2)(id=3)(id=4))"
  end

  specify "simple == with variables" do
    me = 'chris'
    filter = LDAPUser.select { |m| m.name == me }.to_s
    filter.should == "(name=#{me})"
  end
  
  specify "simple == with true" do
    filter = LDAPUser.select { |m| m.disabled == true }.to_s
    filter.should == "(disabled=TRUE)"
  end
  
  xspecify "implicit true" do
    filter = LDAPUser.select { |m| m.disabled }.to_s
    filter.should == "(disabled=TRUE)"
  end
  
  specify "predicate method" do
    filter = LDAPUser.select { |m| m.disabled? }.to_s
    filter.should == "(disabled=TRUE)"
  end
end

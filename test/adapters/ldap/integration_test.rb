require File.dirname(__FILE__) + '/helper'

context "LDAP model after including LDAP Adapter" do
  specify "should still have original find method" do
    LDAPUser.find(:all).should == "dummy find method"
  end
  
end
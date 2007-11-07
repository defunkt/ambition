require File.dirname(__FILE__) + '/helper'

context "Inline Ruby" do
  xspecify "should know what to return" do
    name = 'David'
    sql = User.select { |u| name.nil? || u.name == name }.to_s
    sql.should == "SELECT * FROM users WHERE (users.name = 'David')"
  end
end

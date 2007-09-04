require File.dirname(__FILE__) + '/helper'

context "Joins" do
  specify "simple == on an association" do
    sql = User.select { |m| m.account.email == 'chris@ozmm.org' }
    sql.to_hash.should ==  { 
      :conditions => "accounts.email = 'chris@ozmm.org'", 
      :include => [:account] 
    }
  end

  specify "simple mixed == on an association" do
    sql = User.select { |m| m.name == 'chris' && m.account.email == 'chris@ozmm.org' }
    sql.to_hash.should ==  { 
      :conditions => "(users.name = 'chris' AND accounts.email = 'chris@ozmm.org')", 
      :include => [:account] 
    }
  end

  specify "multiple associations" do
    sql = User.select { |m| m.ideas.title == 'New Freezer' || m.invites.email == 'pj@hyett.com' }
    sql.to_hash.should ==  { 
      :conditions => "(ideas.title = 'New Freezer' OR invites.email = 'pj@hyett.com')",
      :include => [:ideas, :invites]
    }
  end

  specify "non-existant associations" do
    sql = User.select { |m| m.liquor.brand == 'Jack' }
    should.raise { sql.to_hash } 
  end

  specify "in order" do
    sql = User.sort_by { |m| m.ideas.title }
    sql.to_hash.should ==  { 
      :order   => "ideas.title",
      :include => [:ideas]
    }
  end

  specify "in a more complex order" do
    sql = User.sort_by { |m| [ m.ideas.title, -m.invites.email ] }
    sql.to_hash.should ==  { 
      :order   => "ideas.title, invites.email DESC",
      :include => [:ideas, :invites]
    }
  end
end

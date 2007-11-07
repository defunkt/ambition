require File.dirname(__FILE__) + '/helper'

context "Joins" do
  xspecify "simple == on an association" do
    sql = User.select { |m| m.account.email == 'chris@ozmm.org' }
    sql.to_hash.should ==  { 
      :conditions => "accounts.email = 'chris@ozmm.org'", 
      :include => [:account] 
    }
  end

  xspecify "simple mixed == on an association" do
    sql = User.select { |m| m.name == 'chris' && m.account.email == 'chris@ozmm.org' }
    sql.to_hash.should ==  { 
      :conditions => "(users.name = 'chris' AND accounts.email = 'chris@ozmm.org')", 
      :include => [:account] 
    }
  end

  xspecify "multiple associations" do
    sql = User.select { |m| m.ideas.title == 'New Freezer' || m.invites.email == 'pj@hyett.com' }
    sql.to_hash.should ==  { 
      :conditions => "(ideas.title = 'New Freezer' OR invites.email = 'pj@hyett.com')",
      :include => [:ideas, :invites]
    }
  end

  xspecify "belongs_to" do
    sql = User.select { |m| m.account.id > 20 }
    sql.to_hash.should ==  { 
      :conditions => "accounts.id > 20",
      :include    => [:account]
    }
  end

  xspecify "complex joins have no to_s" do
    sql = User.select { |m| m.account.id > 20 }
    should.raise { sql.to_s }
  end

  xspecify "non-existant associations" do
    sql = User.select { |m| m.liquor.brand == 'Jack' }
    should.raise { sql.to_hash } 
  end

  xspecify "in order" do
    sql = User.sort_by { |m| m.ideas.title }
    sql.to_hash.should ==  { 
      :order   => "ideas.title",
      :include => [:ideas]
    }
  end

  xspecify "in a more complex order" do
    sql = User.sort_by { |m| [ m.ideas.title, -m.invites.email ] }
    sql.to_hash.should ==  { 
      :order   => "ideas.title, invites.email DESC",
      :include => [:ideas, :invites]
    }
  end
end

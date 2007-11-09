require File.dirname(__FILE__) + '/helper'

context "ActiveRecord Adapter" do
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

    specify "belongs_to" do
      sql = User.select { |m| m.account.id > 20 }
      sql.to_hash.should ==  { 
        :conditions => "accounts.id > 20",
        :include    => [:account]
      }
    end

    specify "complex joins have no to_s" do
      sql = User.select { |m| m.account.id > 20 }
      should.raise { sql.to_s }
    end

    specify "non-existant associations" do
      should.raise(NoMethodError) { User.select { |m| m.liquor.brand == 'Jack' } }
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
end

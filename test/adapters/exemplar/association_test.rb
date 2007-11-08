# Analog of the join_test.rb in the ActiveRecord adapter.
# Not all adapters will need these behaviors.  E.g. there are no joins in LDAP.
# CouchDb doesn't so much have joins as it has the capacity for creative
# use of its views.

require File.dirname(__FILE__) + '/helper'

context "Object associations" do
  xspecify "simple ==" do
    result = User.select { |m| m.account.email == 'chris@ozmm.org' }
  end

  xspecify "simple mixed == on object and an association" do
    result = User.select { |m| m.name == 'chris' && m.account.email == 'chris@ozmm.org' }
  end

  xspecify "multiple associations" do
    result = User.select { |m| m.ideas.title == 'New Freezer' || m.invites.email == 'pj@hyett.com' }
  end

  xspecify "non-existant associations" do
    result = User.select { |m| m.liquor.brand == 'Jack' }
    should.raise { result.to_hash } 
  end

  xspecify "simple order by association attribute" do
    result = User.sort_by { |m| m.ideas.title }
  end

  xspecify "in a more complex order" do
    result = User.sort_by { |m| [ m.ideas.title, -m.invites.email ] }
  end
end

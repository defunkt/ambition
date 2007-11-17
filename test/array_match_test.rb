require File.dirname(__FILE__) + '/helper'

context "Array#=~" do
  specify "simple array" do
    assert [:call] =~ [:call]
  end

  specify "kinda simple array" do
    assert [:call, :kinda] =~ [:call, :kinda]
  end

  specify "simple matching" do
    assert [:call, :matching] =~ [:call, :X]
  end

  specify "more complex matching" do
    assert [:call, [:dvar, :blah], :matching] =~ [:call, [:X, :blah], :X]
  end

  specify "failed complex matching" do
    assert [:call, [:dvar, :blah], :matching] !~ [:call, [:dvar, :who], :X]
  end
  
  specify "array wildcard matching" do
    assert [:array, [:lit, true]] =~ [:array, :X]
  end
  
  specify "mixed type matching" do
    assert [:lit, true] =~ [:lit, :X]
  end
  
  specify "failed mixed type matching" do
    assert [:lit, true] !~ [:lit, false]
  end
end

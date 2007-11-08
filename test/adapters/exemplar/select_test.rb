context "Exemplar Adapter :: Select" do
  xspecify "simple ==" do
    selector = User.select { |m| m.name == 'jon' }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple !=" do
    selector = User.select { |m| m.name != 'jon' }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == && ==" do
    selector = User.select { |m| m.name == 'jon' && m.age == 21 }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == || ==" do
    selector = User.select { |m| m.name == 'jon' || m.age == 21 }
    selector.to_s.should == %Q(foo)
  end

  xspecify "mixed && and ||" do
    selector = User.select { |m| m.name == 'jon' || m.age == 21 && m.password == 'pass' }
    selector.to_s.should == %Q(foo)
  end

  xspecify "grouped && and ||" do
    selector = User.select { |m| (m.name == 'jon' || m.name == 'rick') && m.age == 21 }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple >/<" do
    selector = User.select { |m| m.age > 21 }
    selector.to_s.should == %Q(foo)

    selector = User.select { |m| m.age >= 21 }
    selector.to_s.should == %Q(foo)

    selector = User.select { |m| m.age < 21 }
    selector.to_s.should == %Q(foo)
  end

  xspecify "array.include? item" do
    selector = User.select { |m| [1, 2, 3, 4].include? m.id }
    selector.to_s.should == %Q(foo)
  end

  xspecify "variabled array.include? item" do
    array = [1, 2, 3, 4]
    selector = User.select { |m| array.include? m.id }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == with variables" do
    me = 'chris'
    selector = User.select { |m| m.name == me }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == with method arguments" do
    def test_it(name)
      selector = User.select { |m| m.name == name }
      selector.to_s.should == %Q(foo)
    end

    test_it('chris')
  end

  xspecify "simple == with instance variables" do
    @me = 'chris'
    selector = User.select { |m| m.name == @me }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == with instance variable method call" do
    require 'ostruct'
    @person = OpenStruct.new(:name => 'chris')

    selector = User.select { |m| m.name == @person.name }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == with global variables" do
    $my_name = 'boston'
    selector = User.select { |m| m.name == $my_name }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple == with method call" do
    def band
      'skinny puppy'
    end

    selector = User.select { |m| m.name == band }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple =~ with string" do
    selector = User.select { |m| m.name =~ 'chris' }
    selector.to_s.should == %Q(foo)

    selector = User.select { |m| m.name =~ 'chri%' }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple !~ with string" do
    selector = User.select { |m| m.name !~ 'chris' }
    selector.to_s.should == %Q(foo)

    selector = User.select { |m| !(m.name =~ 'chris') }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple =~ with regexp" do
    selector = User.select { |m| m.name =~ /chris/ }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple =~ with regexp flags" do
    selector = User.select { |m| m.name =~ /chris/i }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple downcase" do
    selector = User.select { |m| m.name.downcase =~ 'chris%' }
    selector.to_s.should == %Q(foo)
  end

  xspecify "simple upcase" do
    selector = User.select { |m| m.name.upcase =~ 'chris%' }
    selector.to_s.should == %Q(foo)
  end

  xspecify "undefined equality symbol" do
    should.raise { User.select { |m| m.name =* /chris/ } }
  end

  xspecify "block variable / assigning variable conflict" do
    m = User.select { |m| m.name == 'chris' }
    m.should == %Q(foo)
  end
  
  xspecify "simple == with inline ruby" do
    selector = User.select { |m| m.created_at == 2.days.ago(:db) }
    selector.to_s.should == %Q(foo)
  end

  xspecify "inspect" do
    User.select { |u| u.name }.inspect.should.match %r(call #to_s or #to_hash)
  end
end
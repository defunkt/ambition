context "Exemplar Adapter :: Select" do
  xspecify "simple ==" do
    translator = User.select { |m| m.name == 'jon' }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple !=" do
    translator = User.select { |m| m.name != 'jon' }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == && ==" do
    translator = User.select { |m| m.name == 'jon' && m.age == 21 }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == || ==" do
    translator = User.select { |m| m.name == 'jon' || m.age == 21 }
    translator.to_s.should == %Q(foo)
  end

  xspecify "mixed && and ||" do
    translator = User.select { |m| m.name == 'jon' || m.age == 21 && m.password == 'pass' }
    translator.to_s.should == %Q(foo)
  end

  xspecify "grouped && and ||" do
    translator = User.select { |m| (m.name == 'jon' || m.name == 'rick') && m.age == 21 }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple >/<" do
    translator = User.select { |m| m.age > 21 }
    translator.to_s.should == %Q(foo)

    translator = User.select { |m| m.age >= 21 }
    translator.to_s.should == %Q(foo)

    translator = User.select { |m| m.age < 21 }
    translator.to_s.should == %Q(foo)
  end

  xspecify "array.include? item" do
    translator = User.select { |m| [1, 2, 3, 4].include? m.id }
    translator.to_s.should == %Q(foo)
  end

  xspecify "variabled array.include? item" do
    array = [1, 2, 3, 4]
    translator = User.select { |m| array.include? m.id }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == with variables" do
    me = 'chris'
    translator = User.select { |m| m.name == me }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == with method arguments" do
    def test_it(name)
      translator = User.select { |m| m.name == name }
      translator.to_s.should == %Q(foo)
    end

    test_it('chris')
  end

  xspecify "simple == with instance variables" do
    @me = 'chris'
    translator = User.select { |m| m.name == @me }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == with instance variable method call" do
    require 'ostruct'
    @person = OpenStruct.new(:name => 'chris')

    translator = User.select { |m| m.name == @person.name }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == with global variables" do
    $my_name = 'boston'
    translator = User.select { |m| m.name == $my_name }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple == with method call" do
    def band
      'skinny puppy'
    end

    translator = User.select { |m| m.name == band }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple =~ with string" do
    translator = User.select { |m| m.name =~ 'chris' }
    translator.to_s.should == %Q(foo)

    translator = User.select { |m| m.name =~ 'chri%' }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple !~ with string" do
    translator = User.select { |m| m.name !~ 'chris' }
    translator.to_s.should == %Q(foo)

    translator = User.select { |m| !(m.name =~ 'chris') }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple =~ with regexp" do
    translator = User.select { |m| m.name =~ /chris/ }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple =~ with regexp flags" do
    translator = User.select { |m| m.name =~ /chris/i }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple downcase" do
    translator = User.select { |m| m.name.downcase =~ 'chris%' }
    translator.to_s.should == %Q(foo)
  end

  xspecify "simple upcase" do
    translator = User.select { |m| m.name.upcase =~ 'chris%' }
    translator.to_s.should == %Q(foo)
  end

  xspecify "undefined equality symbol" do
    should.raise { User.select { |m| m.name =* /chris/ } }
  end

  xspecify "block variable / assigning variable conflict" do
    m = User.select { |m| m.name == 'chris' }
    m.should == %Q(foo)
  end
  
  xspecify "simple == with inline ruby" do
    translator = User.select { |m| m.created_at == 2.days.ago(:db) }
    translator.to_s.should == %Q(foo)
  end

  xspecify "inspect" do
    User.select { |u| u.name }.inspect.should.match %r(call #to_s or #to_hash)
  end
end
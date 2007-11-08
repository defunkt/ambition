context "Exemplar Adapter :: Detect" do
  specify "simple ==" do
    User.detect { |m| m.name == 'chris' }
  end

  specify "nothing found" do
    User.detect { |m| m.name == 'chris' }.should.be.nil
  end
end

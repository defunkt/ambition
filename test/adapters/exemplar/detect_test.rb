context "Exemplar Adapter :: Detect" do
  xspecify "simple ==" do
    User.detect { |m| m.name == 'chris' }
  end

  xspecify "nothing found" do
    User.detect { |m| m.name == 'chris' }.should.be.nil
  end
end

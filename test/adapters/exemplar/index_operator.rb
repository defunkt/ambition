xcontext "Exemplar Adapter :: [] operator" do
  specify "finds a single row" do
    User.expects(:find).with(1)
    User[1]
  end
end
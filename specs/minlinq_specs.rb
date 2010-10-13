require "../lib/minlinq"
require "spec"

describe "Use a FEnumerable monad" do

  describe "Create and sum a range" do

    it "should sum to 10 from a range of 1 to 4" do
      FEnumerable.range(1, 4).sum.should == 10
    end

  end

end

describe "Use a FObservable monad" do

  describe "Create and sum a range" do

    it "should sum to 10 from a range of 1 to 4" do
      FObservable.range(1, 4).sum.should == 10
    end

  end

end

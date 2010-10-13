require "../lib/maybe"
require "spec"

describe "Use a maybe monad" do

  # Called before each example.
  before(:each) do
    @subject = Maybe.new( 1 )
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "creates a maybe monad" do
    #To change this template use File | Settings | File Templates.
    @subject.is_a? Maybe
  end

  it "should have a value of 1" do
    @subject.value.should == 1
  end

  it "should bind to a method and return the identity plus 2" do
    result = @subject.bind { |i| Maybe.new( i+2 ) }
    result.value.should == 3
  end
end

describe "Initialize a nil Maybe monad" do
  
  # Called before each example.
  before(:each) do
    @subject = Maybe.new( nil )
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "creates a maybe monad" do
    #To change this template use File | Settings | File Templates.
    @subject.is_a? Maybe
  end

  it "should have a value of nil" do
    @subject.value.should == nil
  end

  it "should bind to a method and return nil" do
    result = @subject.bind { |i| Maybe.new( i+2 ) }
    result.value.should == nil
  end
end

describe "Test calculating a sum of the reciprocal of a set of numbers" do
  def divide(x, y)
    Maybe.new(y == 0 ? nil : x/y)
  end

  def totalResistance(r1, r2, r3)
    divide(1, r1).bind do |x|
      divide(1, r2).bind do |y|
        divide(1, r3).bind do |z|
          divide(1, x + y + z)
        end
      end
    end
  end

  describe "given 0.01, 0.75, and 0.33" do
    it "should return 0.009581881533" do
      totalResistance(0.01, 0.75, 0.33).value.should == 1.0/(1.0/0.01+1.0/0.75+1.0/0.33)
    end
  end

  describe "given 0.00, 0.55, and 0.75" do
    it "should return nil" do
      totalResistance(0.00, 0.55, 0.75).value.should == nil
    end
  end
end

describe "Test monad rules" do

  # monad rules taken from http://moonbase.rydia.net/mental/writings/programming/monads-in-ruby/01identity
  # and http://james-iry.blogspot.com/2007_10_01_archive.html
  
  it "should return the same values for map and bind, passing monad rule 0" do
    f = Proc.new { |x| x*2 }
    m = Maybe.new( 5 )
    m.map( &f ).value.should == m.bind { |x| Maybe.new( f[x] ) }.value
  end

  it "should have the same effect as calling the block directly, passing monad rule 1" do
    f = Proc.new { |y| Maybe.new( y.to_s  ) }
    x = 1
    Maybe.new(x).bind { |y| f[y] }.value.should == f[x].value
  end

  it "should return the same value as the original, wrapped up again, passing monad rule 2" do
    x = Maybe.new(1)
    x.bind { |y| Maybe.new(y) }.value.should == x.value
  end
  
  it "should return equivalent results when calling nested blocks or calling them sequentially, passing monad rule 3" do
    f = Proc.new { |x| Maybe.new( x*2 ) }
    g = Proc.new { |x| Maybe.new( x+1 ) }
    m = Maybe.new( 3 )
    n = Maybe.new( 3 )
    n.bind { |x| f[x].bind { |y| g[y] } }.value.should == m.bind { |x| f[x] }.bind { |x| g[x] }.value
  end

end

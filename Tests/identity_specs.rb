require "../identity"
require "spec"

describe "Use an identity monad" do

  # Called before each example.
  before(:each) do
    @subject = Identity.new( 1 )
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "creates an identity monad" do
    #To change this template use File | Settings | File Templates.
    @subject.is_a? Identity
  end

  it "should have a value of 1" do
    @subject.value.should == 1
  end

  it "should bind to a method and return the identity plus 2" do
    result = @subject.bind { |i| Identity.new( i+2 ) }
    result.value.should == 3
  end
end

describe "Test monad rules" do

  # monad rules taken from http://moonbase.rydia.net/mental/writings/programming/monads-in-ruby/01identity
  # and http://james-iry.blogspot.com/2007_10_01_archive.html
  
  it "should return the same values for map and bind, passing monad rule 0" do
    f = Proc.new { |x| x*2 }
    m = Identity.new( 5 )
    
    mapped = m.map( &f )
    bound = m.bind { |x| Identity.new( f[x] ) }
    
    mapped.is_a? Identity
    bound.is_a? Identity
    mapped.value.should == bound.value
  end

  it "should have the same effect as calling the block directly, passing monad rule 1" do
    f = Proc.new { |y| Identity.new( y.to_s  ) }
    x = 1
    
    direct = f[x]
    bound = Identity.new(x).bind { |y| f[y] }
    
    direct.is_a? Identity
    bound.is_a? Identity
    direct.value.should == bound.value
  end

  it "should return the same value as the original, wrapped up again, passing monad rule 2" do
    x = Identity.new(1)
    x.bind { |y| Identity.new(y) }.value.should == x.value
  end
  
  it "should return equivalent results when calling nested blocks or calling them sequentially, passing monad rule 3" do
    f = Proc.new { |x| Identity.new( x*2 ) }
    g = Proc.new { |x| Identity.new( x+1 ) }
    m = Identity.new( 3 )
    n = Identity.new( 3 )
    n.bind { |x| f[x].bind { |y| g[y] } }.value.should == m.bind { |x| f[x] }.bind { |x| g[x] }.value
  end

end
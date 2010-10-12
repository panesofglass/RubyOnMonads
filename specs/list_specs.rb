require "../lib/list"
require "spec"

describe "Use a list monad" do

  # Called before each example.
  before(:each) do
    value1 = OpenStruct.new
    value1.children = [1,2,3,4]
    
    value2 = OpenStruct.new
    value2.children = [5,6,7,8]
    
    @subject = [ value1, value2 ]
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "creates an Array monad" do
    #To change this template use File | Settings | File Templates.
    @subject.is_a? Array
  end

  it "should have a property children with the first child having a value of 1" do
    @subject.first.children.first.should == 1
    @subject.first.children.length.should == 4
  end

  it "should return a flattened array of all children" do
    result = @subject.bind { |i| i.children }
    result.first.should == 1
    result.length.should == 8
  end
end

describe "Test monad rules" do

  # monad rules taken from http://moonbase.rydia.net/mental/writings/programming/monads-in-ruby/01identity
  # and http://james-iry.blogspot.com/2007_10_01_archive.html
  
  it "should return the same values for map and bind, passing monad rule 0" do
    f = Proc.new { |x| x*2 }
    m = [5]
    m.map( &f ).first.should == m.bind { |x| [ f[x] ] }.first
  end

  it "should have the same effect as calling the block directly, passing monad rule 1" do
    f = Proc.new { |y| [y.to_s] }
    x = 1
    [x].bind { |y| f[y] }.first.should == f[x].first
  end

  it "should return the same value as the original, wrapped up again, passing monad rule 2" do
    x = [1]
    x.bind { |y| [y] }.first.should == x.first
  end
  
  it "should return equivalent results when calling nested blocks or calling them sequentially, passing monad rule 3" do
    f = Proc.new { |x| [x*2] }
    g = Proc.new { |x| [x+1] }
    m = [3]
    n = [3]
    n.bind { |x| f[x].bind { |y| g[y] } }.first.should == m.bind { |x| f[x] }.bind { |x| g[x] }.first
  end

end

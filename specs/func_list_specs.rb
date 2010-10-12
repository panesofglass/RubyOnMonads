require "../lib/list"
require "spec"

describe "Create a FuncList" do

  # Called before each example.
  before(:each) do
    @subject = FuncList.new
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "should create a FuncList" do
    @subject.is_a? FuncList
  end
  
  it "should create an empty FuncList" do
    @subject.is_empty?
  end
  
end

describe "Create a FuncList with FuncList::cons" do

  # Called before each example.
  before(:each) do
    @value1 = OpenStruct.new
    @value1.children = [1,2,3,4]
    
    @value2 = OpenStruct.new
    @value2.children = [5,6,7,8]

    @subject = FuncList::cons(@value1, FuncList::cons(@value2, FuncList::empty))
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "should have a head value of @value1" do
    @subject.head.should == @value1
  end
  
  it "should have a tail value of a FuncList containing a head of @value2 and a tail of an empty FuncList" do
    @subject.tail.head.should == @value2
    @subject.tail.tail.is_a? FuncList
    @subject.tail.tail.is_empty?
  end
  
end

describe "Summing a FuncList of integers" do

  before(:each) do    
    @subject = FuncList::cons(1, FuncList::cons(2, FuncList::cons(3, FuncList::cons(4, FuncList::cons(5, FuncList::empty)))))
  end
  
  after(:each) do
    # Do nothing
  end
  
  it "should sum the numbers" do
    result = sum_list( @subject )
    result.should == 15
  end
  
  private
  
  def sum_list( numbers )
    numbers.is_empty? ? 0 : numbers.head + sum_list( numbers.tail )
  end

end

describe "Mapping a function to add two to each number in a FuncList" do

  before(:each) do    
    @subject = FuncList::cons(1, FuncList::cons(2, FuncList::cons(3, FuncList::cons(4, FuncList::cons(5, FuncList::empty)))))
  end
  
  after(:each) do
    # Do nothing
  end
  
  it "should add two to the head" do
    result = @subject.map { |x| x+2 }
    result.head.should == 3
  end
  
  it "should add two to the head of the tail" do
    result = @subject.map { |x| x+2 }
    result.tail.head.should == 4
  end

end

describe "Filtering a FuncList for numbers divisible by 2" do
  
  before(:each) do    
    @subject = FuncList::cons(1, FuncList::cons(2, FuncList::cons(3, FuncList::cons(4, FuncList::cons(5, FuncList::empty)))))
  end
  
  after(:each) do
    # Do nothing
  end
  
  it "should filter 2 to the head" do
    result = @subject.filter { |x| x%2 == 0 }
    result.head.should == 2
  end
  
  it "should filter 4 to head of the tail" do
    result = @subject.filter { |x| x%2 == 0 }
    result.tail.head.should == 4
  end
  
end

describe "Folding a range of 1..5" do
  
  before(:each) do    
    @subject = FuncList::cons(1, FuncList::cons(2, FuncList::cons(3, FuncList::cons(4, FuncList::cons(5, FuncList::empty)))))
  end
  
  after(:each) do
    # Do nothing
  end
  
  it "should return 120 when the seed is 1" do
    result = @subject.fold( 1, Proc.new { |x, y| x * y } )
    result.should == 120
  end
  
  it "should return 600 when the seed is 5" do
    result = @subject.fold( 5, Proc.new{ |x, y| x * y } )
    result.should == 600
  end

end

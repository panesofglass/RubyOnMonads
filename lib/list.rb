module List

  def bind( &block )
    # Map then flatten (this is, after all, called flatMap in Scala for a reason).
    # Unfortunately, the Array#flatten flattens all levels and we just want the first level flattened,
    # so we have to use inject to get the desired flattening.
    map( &block ).inject( [] ) { |combined, arr| combined + arr }
  end
  
  def filter( &block )
    filtered = []
    self.each { |el| filtered << el if block.call(el) }
    filtered
  end
  
  def fold( init, &block )
    temp = init
    self.each { |el| block.call( el, temp ) }
    temp
  end

end

class Array
  include List
end

class FuncList
  include Enumerable
  
  attr_reader :head
  attr_reader :tail

  def initialize( head = nil, tail = [] )
    @head = head
    @tail = tail
  end
  
  def FuncList::empty
    new
  end
  
  def FuncList::cons( head, tail )
    new( head, tail )
  end
  
  def bind( &block )
    # Map then flatten (this is, after all, called flatMap in Scala for a reason).
    map( &block ) # Need to define a flatten method that pulls up the FuncLists within the FuncList by one level.
  end
  
  def map( &block )
    head = block.call( @head )
    tail = @tail.is_empty? ? @tail : @tail.map( &block )
    FuncList::cons( head, tail )
  end
  
  def filter( &block )
    if (is_empty?)
      self
    else
      tail = @tail.filter( &block )
      block.call( @head ) ? FuncList::cons(@head, tail) : tail
    end
  end
  
  def fold( init, aggregator )
    if (is_empty?)
      init
    else
      aggregator.call( @tail.fold( init, aggregator ), @head )
    end
  end
  
  def is_empty?
    head == nil && tail == []
  end
  
end

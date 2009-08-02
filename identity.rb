class Identity
  attr_reader :value

  def initialize( value )
    @value = value
  end

  def bind
    yield @value
  end
  
  def map
    Identity.new( yield @value )
  end

end
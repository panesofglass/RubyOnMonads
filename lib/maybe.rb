class Maybe
  attr_reader :value
  
  def initialize(value)
    @value = value
  end

  def Maybe.empty
    Maybe.new(nil)
  end

  def empty?
    @value.nil?
  end

  def Maybe.return x
    Maybe.new(x)
  end

  def bind
    if (@value == nil)
      Maybe.new(nil)
    else
      yield @value
    end
  end
  
  def map
    if (@value == nil)
      Maybe.new(nil)
    else
      Maybe.new(yield @value)
    end
  end

end

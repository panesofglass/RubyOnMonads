require 'maybe'

module FEnumerable

  def empty
    lambda { lambda { Maybe.new(nil) } }
  end

  def return(value)
    lambda do
      i = 0
      lambda { (i += 1) == 1 ? Maybe.new(value) : Maybe.new(nil) }
    end
  end

  def bind(&selector)
    source = self
    lambda do
      e = source.call()

      lastOuter = Maybe.new(nil)
      lastInner = Maybe.new(nil)
      innerE = nil

      lambda do
        begin
          while (lastInner.value.nil?) do
            lastOuter = e.call()
            if (lastOuter.value.nil?)
              return Maybe.new(nil)
            else
              innerE = selector.call(lastOuter.value)
            end
            lastInner = innerE.call()
            return lastInner unless lastInner.value.nil?
          end
          lastInner = innerE.call()
        end while (lastInner.value.nil?)
      end
    end
  end

end

module FObservable

  def empty
    lambda { |o| o.call Maybe.new(nil) }
  end

  def return(value)
    lambda do |o|
      o.call Maybe.new(value)
      o.call Maybe.new(nil)
    end
  end

  def bind(&selector)
    source = self
    lambda do |o|
      source.call do |x|
        if (x.value.nil?)
          o.call Maybe.new(nil)
        else
          selector.call(x.value).call { |y| o.call(y) unless y.value.nil?  }
        end
      end
    end
  end

end

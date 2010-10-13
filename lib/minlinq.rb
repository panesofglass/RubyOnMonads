require 'maybe'

module FEnumerable

  def FEnumerable.empty
    lambda { lambda { Maybe.empty } }
  end

  def FEnumerable.return(value)
    lambda do
      i = 0
      lambda { i+=1 == 1 ? Maybe.new(value) : Maybe.empty }
    end
  end

  def bind(&selector)
    lambda do
      e = self.call

      lastOuter = Maybe.empty
      lastInner = Maybe.empty
      innerE = nil

      lambda do
        begin
          while (lastInner.empty?) do
            lastOuter = e.call
            if (lastOuter.empty?)
              return Maybe.empty
            else
              innerE = selector.call(lastOuter.value)
            end
            lastInner = innerE.call
            return lastInner unless lastInner.empty?
          end
          lastInner = innerE.call
        end while (lastInner.empty?)
      end
    end
  end

  def fold(seed, &f) =
    e = self.call
    loop = lambda do |v, acc|
      if (v.empty?)
        acc
      else
        loop.call(e.call, f.call(acc, v.value))
      end
    end
    loop.call(e.call, seed)
  end

  def FEnumerable.unfold(seed, &generator) =
    lambda do
      lambda do
        res = generator.call(seed)
        if (res.empty?)
          res
        else
          next = res.value[1]
          Maybe.new(res.value[0])
        end
      end
    end
  end

  def filter(&f) =
    self.bind { |t| f.call(t) ? FEnumerable.return(t) : FEnumerable.empty }
  end

  def map(&selector) =
    self.bind { |t| selector.call(t) }
  end

  def FEnumerable.range(from, length) =
    FEnumerable.unfold from { |x| x < from + length ? Maybe.new([x,x+1]) : Maybe.empty }
  end

  def sum
    self.fold 0 { |sum, x| sum + x }
  end

end

module FObservable

  def FObservable.empty
    lambda { |o| o.call Maybe.empty }
  end

  def FObservable.return(value)
    lambda do |o|
      o.call Maybe.new(value)
      o.call Maybe.empty
    end
  end

  def bind(&selector)
    lambda do |o|
      self.call do |x|
        if (x.empty?)
          o.call Maybe.empty
        else
          selector.call(x.value).call { |y| o.call(y) unless y.empty? }
        end
      end
    end
  end

  def fold(seed, &f) =
    result = seed
    stop = false
    self.call lambda do |x|
      if (x.empty?)
        stop = true
      elsif (!stop)
        result = f.call(result, x)
      end
    end
    result
  end

  def FObservable.unfold(seed, &generator) =
    lambda do |o|
      loop = lambda do |t|
        res = generator.call(t)
        if (res.empty?)
          o.call(res)
        else
          o.call(Maybe.new(res.value[0]))
          loop.call(res.value[1])
        end
      end
      loop.call(seed)
    end
  end

  def filter(&f) =
    self.bind { |t| f.call(t) ? FObservable.return(t) : FObservable.empty }
  end

  def map(&selector) =
    self.bind { |t| selector.call(t) }
  end

  def FObservable.range(from, length) =
    FObservable.unfold from { |x| x < from + length ? Maybe.new([x,x+1]) : Maybe.empty }
  end

  def sum
    self.fold 0 { |sum, x| sum + x }
  end

end

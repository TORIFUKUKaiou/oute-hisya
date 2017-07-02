class Bishop
  def diffs
    ary = []
    ([*1..8]).zip([*1..8]) do |diff|
      ary << diff
    end
    ([*1..8]).zip((1..8).map{|n| -n}) do |diff|
      ary << diff
    end
    ((1..8).map{|n| -n}).zip([*1..8]) do |diff|
      ary << diff
    end
    ((1..8).map{|n| -n}).zip((1..8).map{|n| -n}) do |diff|
      ary << diff
    end
    ary
  end

  def to_s
    '角'
  end
end

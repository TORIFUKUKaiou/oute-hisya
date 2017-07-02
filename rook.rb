class Rook
  def diffs
    ary = []

    (1..8).each do |diff|
      ary << [0, -diff]
    end

    (1..8).each do |diff|
      ary << [0, diff]
    end

    (1..8).each do |diff|
      ary << [-diff, 0]
    end

    (1..8).each do |diff|
      ary << [diff, 0]
    end

    ary
  end

  def to_s
    '飛'
  end
end

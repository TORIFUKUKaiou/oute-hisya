# とりあえず王と飛車の組み合わせのみ
class Pair
  attr_reader :koma_position1, :koma_position2

  def initialize(koma_position1, koma_position2)
    @koma_position1 = koma_position1
    @koma_position2 = koma_position2
  end

  def ==(other)
    other.is_a?(Pair) &&
    koma_position1 == other.koma_position1 &&
    koma_position2 == other.koma_position2
  end

  def to_s
    "#{koma_position1.to_s}#{koma_position2.to_s}"
  end
end

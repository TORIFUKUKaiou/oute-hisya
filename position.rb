class Position
  attr_reader :x, :y

  KANSUJI_HASH = {1 => '一', 2 => '二', 3 => '三', 4 => '四', 5 => '五', 6 => '六', 7 => '七', 8 => '八', 9 => '九'}

  def initialize(x, y)
    @x = x
    @y = y
  end

  def move(diff_x, diff_y)
    @x += diff_x
    @y += diff_y
    # exist? が偽ならExceptionがいいのかなあ
  end

  def exist?
    x >= 1 && x <= 9 && y >= 1 && y <= 9
  end

  def eql?(other)
    other.is_a?(Position) && @x == other.x && @y == other.y
  end

  def hash
    [x, y].hash
  end

  def to_s
    "#{x}#{KANSUJI_HASH[y]}"
  end

  alias_method :==, :eql?
end

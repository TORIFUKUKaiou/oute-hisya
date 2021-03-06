class Result
  attr_reader :pair, :bishop_position

  def initialize(pair, bishop_position)
    @pair = pair
    @bishop_position = bishop_position
  end

  def to_s
    "#{@pair}#{@bishop_position}"
  end
end

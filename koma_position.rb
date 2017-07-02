class KomaPosition
  attr_reader :koma, :position, :sente

  def initialize(koma, position, sente)
    @koma = koma
    @position = position
    @sente = sente
  end

  def to_s
    "#{@sente ? '▲' : '△'}#{@position}#{@koma}"
  end

  def eql?(other)
    other.is_a?(KomaPosition) &&
    koma == other.koma &&
    position == other.position &&
    sente == other.sente
  end

  def hash
    [koma, position, sente].hash
  end

  def <=>(other)
    position <=> other.position
  end

  alias_method :==, :eql?
end

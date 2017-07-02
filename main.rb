require 'position'
require 'king'
require 'rook'
require 'bishop'
require 'koma_position'
require 'pair'
require 'result'

# xの1から9, yの一から九の積をPositionの配列にする
positions = ([*1..9]).product([*1..9]).inject([]) do |memo, (x, y)|
  memo << Position.new(x, y)
end

# 駒インスタンス
king = King.new
rook = Rook.new
bishop = Bishop.new

# 駒が動ける範囲
king_diffs   = king.diffs
rook_diffs   = rook.diffs
bishop_diffs = bishop.diffs

# キーがPosition(初期位置)、値が移動可能なPositionが配列になっているHash
king_movable_positions   = Hash.new {|h, position| h[position] = []}
rook_movable_positions   = Hash.new {|h, position| h[position] = []}
bishop_movable_positions = Hash.new {|h, position| h[position] = []}
positions.each do |position|
  key_position = Position.new(position.x, position.y)

  king_diffs.each do |(diff_x, diff_y)|
    move_position = Position.new(position.x, position.y)
    move_position.move(diff_x, diff_y)
    king_movable_positions[key_position] << move_position if move_position.exist?
  end

  rook_diffs.each do |(diff_x, diff_y)|
    move_position = Position.new(position.x, position.y)
    move_position.move(diff_x, diff_y)
    rook_movable_positions[key_position] << move_position if move_position.exist?
  end

  bishop_diffs.each do |(diff_x, diff_y)|
    move_position = Position.new(position.x, position.y)
    move_position.move(diff_x, diff_y)
    bishop_movable_positions[key_position] << move_position if move_position.exist?
  end
end

# 玉と飛車の初期位置の全パターン 81 x 80 = 6480通り
king_rook_ary = []
king_rook_result_ary = []
positions.permutation(2).to_a.each do |p1, p2|
  # 角の初期位置
  positions.each do |bishop_position|
    if bishop_position == p1 || bishop_position == p2
      # 玉 or 飛車の上に角はおけないのでスキップ
    elsif king_movable_positions[p1].include?(bishop_position) || rook_movable_positions[p2].include?(bishop_position)
      # 玉 or 飛車が動いたら角を取れる場合は除外
    else
      # 角が動くと玉と飛車の両取りになる位置に配置できるか?
      if bishop_movable_positions[bishop_position].include?(p1) && bishop_movable_positions[bishop_position].include?(p2)
        king_rook_pair = Pair.new(KomaPosition.new(king, p1, true), KomaPosition.new(rook, p2, true))
        # [▲1一玉▲2二飛△3三角]、[▲1一玉▲2二飛△4四角]、[▲1一玉▲2二飛△5五角]…みたいなやつは代表して最初に見つかったものだけにする
        unless king_rook_ary.include?(king_rook_pair)
          king_rook_ary << king_rook_pair
          king_rook_result_ary << Result.new(king_rook_pair, KomaPosition.new(bishop, bishop_position, false))
        end
      end
    end
  end
end


rook_king_ary = []
rook_king_result_ary = []
positions.permutation(2).to_a.each do |p1, p2|
  # 角の初期位置
  positions.each do |bishop_position|
    if bishop_position == p1 || bishop_position == p2
      # 玉 or 飛車の上に角はおけないのでスキップ
    elsif king_movable_positions[p2].include?(bishop_position) || rook_movable_positions[p1].include?(bishop_position)
      # 王 or 飛車が動いたら角を取れる場合は除外
    else
      # 角が動くと王と飛車の両取りになる位置に配置できるか?
      if bishop_movable_positions[bishop_position].include?(p1) && bishop_movable_positions[bishop_position].include?(p2)
        rook_king_pair = Pair.new(KomaPosition.new(king, p2, true), KomaPosition.new(rook, p1, true))
        # [▲1一玉▲2二飛△3三角]、[▲1一玉▲2二飛△4四角]、[▲1一玉▲2二飛△5五角]…みたいなやつは代表して最初に見つかったものだけにする
        unless rook_king_ary.include?(rook_king_pair)
          rook_king_ary << rook_king_pair
          rook_king_result_ary << Result.new(rook_king_pair, KomaPosition.new(bishop, bishop_position, false))
        end
      end
    end
  end
end

over_nanadan_king_result_ary = (king_rook_result_ary + rook_king_result_ary).select do |result|
  result.pair.koma_position1.position.y >= 7
end

king_position_cnt_hash = (king_rook_result_ary + rook_king_result_ary).inject(Hash.new{|h, k| h[k] = 0}) do |hash, result|
  hash[result.pair.koma_position1] += 1
  hash
end
puts "角で王手飛車取りがかかる玉の位置が多い順"
king_position_cnt_hash.to_a.sort_by(&:last).reverse.each do |(king, cnt)|
  puts "#{king} => #{cnt}"
end

puts "---"
puts "角で王手飛車取りがかかる玉の位置順"
king_position_cnt_hash.to_a.sort_by(&:first).each do |(king, cnt)|
  puts "#{king} => #{cnt}"
end

open('all_result.txt', 'w') do |f|
  (king_rook_result_ary + rook_king_result_ary).sort_by{|result| result.pair.koma_position1}.reverse.each do |result|
    f.puts result
  end
end

open('over_nanadan_king_result.txt', 'w') do |f|
  over_nanadan_king_result_ary.sort_by{|result| result.pair.koma_position1}.reverse.each do |result|
    f.puts result
  end
end

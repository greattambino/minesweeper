class Minesweeper
  attr_accessor :board
  attr_reader   :bombs, :flagged

  def initialize(board = Minesweeper.default_grid, bombs = 5)
    @board = board
    @bombs = generate_bombs(bombs)
    @flagged = []
  end

  def display
    puts "  0  1  2  3  4  5  6  7  8"
    9.times do |idx|
      display_row(idx, board[idx])
    end
    "u suk"
  end

  def display_row(row_num, array)
    print "#{row_num} "
    array.each do |elem|
      print "#{elem}  "
    end
    print "\n"
  end

  def reveal(pos)

    if bombs.include?(pos)
      self[pos] = "*"
    else #reveal neighbors
      queue = [pos]
      until queue.empty?
        current_pos = queue.shift
        self[current_pos] = neighbors_bomb_count(current_pos) if self[current_pos] == "_"
        neighbors(pos).each do |spot|
          queue << spot if neighbors_bomb_count(spot).zero?
        end
      end
    end
  end

  def neighbors?(pos)
    valid_positions = []
    deltas = [
      [ 0,  1],
      [ 1,  1],
      [ 1,  0],
      [ 1, -1],
      [ 0, -1],
      [-1, -1],
      [-1,  0],
      [-1,  1]
    ]
    row, col = pos
    deltas.each do |delta|
      if row + delta.first > 0  && row + delta.last < 9 &&
         col + delta.first  > 0 && col + delta.last < 9

        valid_positions << [row + delta.first, col + delta.last]
       end
    end

    valid_positions
  end

  def neighbors_bomb_count(pos)
    check = neighbors?(pos)
    nearby_bombs = 0

    check.each do |spot|
      nearby_bombs += 1 if bombs.include?(spot)
    end
    nearby_bombs
  end


  def [](pos)
    row, col = pos
    board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    board[row][col] = value
  end

  def flag_bomb(pos)
    self[pos] = "F"
    flagged << pos
  end

  def over?
    won? || lost?
  end

  def lost?
    board.flatten.include?("*")
  end

  def won?
    flagged.sort == bombs.sort
  end

  def generate_bombs(bomb_count)
    bomb_array = []
    until bomb_array.length == bomb_count
      temp = [rand(8), rand(8)]
      bomb_array << temp unless bomb_array.include?(temp)
    end
    bomb_array
  end

  private
  def self.default_grid
    Array.new(9) { Array.new(9, "_") }
  end
end

load "tile.rb"
require "byebug"

class Board
  attr_reader :size

  def initialize(size = 9)
    @grid = Array.new(size) { Array.new(size) }
    @size = size
    @number_of_bombs = 10
    populate_grid
  end

  def reveal(position)
    x,y = position.split(",").map(&:to_i)
    @grid[y][x].reveal
  end

  def populate_grid

    bomb_positions = generate_bomb_positions

    @grid.each_with_index do |row, idx1|
      row.each_with_index do |space, idx2|
        pos = [idx1, idx2]

        if bomb_positions.include?(pos)
          @grid[idx1][idx2] = Tile.new(self, pos, true)
        else
          @grid[idx1][idx2] = Tile.new(self, pos)
        end

      end
    end
  end

  def display
    system "clear"
    x_str = ""
    (0..size-1).to_a.each { |i| x_str += "|#{i}|"}
    puts x_str
    @grid.each.with_index do |row, index|
      row_str = ""
      row.each {|tile| row_str += tile.to_s }
      puts row_str += " |#{index}|"
    end
  end

  def generate_bomb_positions
    bomb_positions = []
    until bomb_positions.length == @number_of_bombs
      row = rand(@size)
      col = rand(@size)
      bomb_positions << [row, col] unless bomb_positions.include?([row, col])
    end
    bomb_positions
  end

  def []=(y, x, val)
    @grid[y][x] = val
  end

  def [](y,x)
    @grid[y][x]
  end

  def valid?(y, x)
    y.between?(0,size-1) && x.between?(0,size-1)
  end
end

# b = Board.new
# b.display
# p b.[](0,0).neighbor_bomb_count

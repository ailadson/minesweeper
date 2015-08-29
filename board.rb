load "tile.rb"
require "colorize"
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
    x, y = parse_position(position)
    @grid[y][x].reveal
  end

  def toggle_flag(position)
    x, y = parse_position(position)
    @grid[y][x].toggle_flag
  end

  def display(current_pos = nil)
    system "clear"

    header = (0..size-1).to_a.inject("") do |header_str, col_idx|
      header_str + "|#{col_idx}|"
    end

    puts header

    @grid.each.with_index do |row, idx1|
      row_str = ""
      row.each_with_index do |tile, idx2|

        row_str += colorize(tile, current_pos)

      end
      puts row_str + " |#{idx1}|"
    end
  end

  def colorize(tile, current_pos)
    if current_pos
      if tile.at_position?(current_pos)
        tile.to_s.colorize(:background => :light_black, :color => :black)
      else
        tile.to_s
      end
    end
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

  def won?
    @grid.flatten.count { |tile| !tile.revealed? } == @number_of_bombs
  end

  def reveal_all
    @grid.each do |row|
      row.each do |tile|
        tile.reveal
      end
    end
  end

  private
  def generate_bomb_positions
    bomb_positions = []
    until bomb_positions.length == @number_of_bombs
      row = rand(@size)
      col = rand(@size)
      bomb_positions << [row, col] unless bomb_positions.include?([row, col])
    end
    bomb_positions
  end

  def parse_position(position)
    position.split(",").map(&:to_i)
  end

  def populate_grid
    bomb_positions = generate_bomb_positions

    @grid.each_with_index do |row, idx1|
      row.each_with_index do |space, idx2|
        pos = [idx1, idx2]
        @grid[idx1][idx2] = Tile.new(self, pos, bomb_positions.include?(pos))
      end
    end
  end
end

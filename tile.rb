require "byebug"

class Tile
  def initialize( board, position, bomb=false)
    @position = position
    @board = board
    @bomb = bomb
  end

  def bomb?
    bomb
  end

  def flagged?
    flag
  end

  def revealed?
    revealed
  end

  def reveal
    return true if flagged? || revealed?
    @revealed = true
    return false if bomb?
    if neighbor_bomb_count.zero?
      neighbors.each { |neighbor| neighbor.reveal }
    end
    true
  end

  def toggle_flag
    @flag = !@flag unless revealed?
  end

  def to_s
    if flagged?
      "|F|"
    elsif  !revealed?
      "|*|"
    else
      if bomb?
        "|B|"
      elsif neighbor_bomb_count > 0
          "|#{neighbor_bomb_count}|"
      else
        "|_|"
      end
    end
  end

  def at_position?(pos)
    pos == position
  end

  private
  attr_reader :position, :bomb, :flag, :revealed

  def neighbor_bomb_count
    neighbors.count do |neighbor|
      raise "Nil neighbor" if neighbor.nil?
      neighbor.bomb?
    end
  end

  def neighbors
    y,x = position
    neighbors = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        y_pos, x_pos = y+row, x+col

        neighbors << @board.[](y_pos, x_pos) if @board.valid?(y_pos, x_pos)
      end
    end
    neighbors
  end
end

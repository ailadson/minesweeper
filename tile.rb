require "byebug"

class Tile
  attr_reader :position, :bomb, :flag, :revealed

  def initialize( board, position, bomb=false)
    @position = position
    @board = board
    @bomb = bomb
    #@revealed = true
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

  def reveal
    @revealed = true
    return false if bomb?
    if neighbor_bomb_count == 0
      neighbors.each { |neighbor| neighbor.respond_to_neighbor_reveal }
    end
    true
  end

  def respond_to_neighbor_reveal
    return if revealed?
    @revealed = true
    if neighbor_bomb_count.zero?
      neighbors.each { |neighbor| neighbor.respond_to_neighbor_reveal }
    end
  end

  def toggle_flag
    @flag = !@flag
  end

  def neighbor_bomb_count
    neighbors.count do |neighbor|
      raise "Nil neighbor" if neighbor.nil?
      neighbor.bomb?
    end
  end

  def to_s
    unless revealed?
      "|*|"
    else
      if bomb?
        "|B|"
      elsif flagged?
        "|F|"
      elsif neighbor_bomb_count > 0
          "|#{neighbor_bomb_count}|"
      else
        "|_|"
      end
    end
  end
end

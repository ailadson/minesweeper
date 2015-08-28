load "board.rb"

class Minesweeper

  def initialize
    @board = Board.new
  end

  def play_turn
    command, data = get_input

    case command
    when "r"
      game_over unless @board.reveal(data)
    end

    @board.display
  end

  def get_input
    puts "What is your next move?"
    gets.chomp.split(" ")
  end

  def game_over
    abort("Game Over")
  end

end

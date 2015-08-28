load "board.rb"

class Minesweeper

  def initialize
    @board = Board.new
  end

  def run
    display_welcome
    until @board.won?
      play_turn
    end
    @board.display
    abort("Congratulations!")
  end

  def play_turn
    @board.display

    command, data = get_input

    case command.downcase
    when "r"
      game_over unless @board.reveal(data)
    when "f"
      @board.toggle_flag(data)
    when "h"
      display_help
    end
  end

  def get_input
    puts "What is your next move?"
    gets.chomp.split(" ")
  end

  def game_over
    @board.reveal_all
    @board.display
    abort("Game Over")
  end

  def display_help
    system "clear"
    puts "THE COMMANDS"
    display_command("reveal", "0,0" )
    display_command("flag", "0,0" )
    display_command("save", "\"filename\"" )
    puts "Enter h to display this page again"
    puts "Press any key to continue"
    gets
  end

  def display_command(name, usage)
    puts "--#{name}"
    puts "  usage: #{name[0]} #{usage}"
    puts ""
  end

  def display_welcome
    puts "Welcome to Minesweeper"
    puts "(Enter \"h\" for help menu, or any other key to play game)"
    command = gets.chomp.downcase
    display_help if command == "h"
  end

end

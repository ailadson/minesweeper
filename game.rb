load "board.rb"
require "yaml"

class Minesweeper

  def initialize
    @board = Board.new
    @current_pos = [0,0]
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
    @board.display(@current_pos)

    command, data = get_input

    case command.downcase
    when "r"
      game_over unless @board.reveal(data)
    when "f"
      @board.toggle_flag(data)
    when "h"
      display_help
    when "s"
      save_game(data)
    when "q"
      abort("Giving up so soon?")
    when "l"
      @board = load_game(data)
    end
  end

  def save_game(filename)
    Dir.mkdir("game_saves") unless File.exists?("game_saves")
    f = filename.split(".").first + ".yaml"
    File.write("game_saves/#{f}", @board.to_yaml)
    abort("Game saved")
  end

  def load_game(filename)
    f = filename.split(".").first + ".yaml"
    YAML::load(File.read("game_saves/#{f}"))
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
    display_command("quit", "")
    display_command("load", "\"filename\"")
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

g = Minesweeper.new
g.run

load "board.rb"
require "yaml"
require 'io/console'

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
    handle_key_press while true
    # command, data = get_input
    #
    # case command.downcase
    # when "r"
    #   game_over unless @board.reveal(data)
    # when "f"
    #   @board.toggle_flag(data)
    # when "h"
    #   display_help
    # when "s"
    #   save_game(data)
    # when "q"
    #   abort("Giving up so soon?")
    # when "l"
    #   @board = load_game(data)
    # end
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
    @board.display(@current_pos)
    abort("Game Over")
  end

  def display_help
    system "clear"
    puts "THE COMMANDS"
    puts "Use the arrow keys to navigate."
    puts "Press ENTER to reveal space."
    puts "Press F to flag space."
    puts "Press S to save the game."
    puts "Press L to load game."
    puts "Press Q to quit game."
    puts ""
    puts "Press H to display this page again"
    puts "Press ENTER key to continue"
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

  def handle_key_press

    c = read_char
    case c
    when "\e[A"
      y, x = @current_pos
      @current_pos = [y-1,x] if @board.valid?(y-1, x)
      @board.display(@current_pos)
    when "\e[B"
      y, x = @current_pos
      @current_pos = [y+1,x] if @board.valid?(y+1, x)
      @board.display(@current_pos)
    when "\e[C"
      y, x = @current_pos
      @current_pos = [y,x+1] if @board.valid?(y, x+1)
      @board.display(@current_pos)
    when "\e[D"
      y, x = @current_pos
      @current_pos = [y,x-1] if @board.valid?(y, x-1)
      @board.display(@current_pos)
    when "\r"
      game_over unless @board.reveal(@current_pos)
      @board.display(@current_pos)
    when " "
      game_over unless @board.reveal(@current_pos)
      @board.display(@current_pos)
    when "f"
      @board.toggle_flag(@current_pos)
      @board.display(@current_pos)
    when "s"
      puts "Choose a file name."
      save_game(gets.chomp)
    when "l"
      puts "What is the file name?"
      @board = load_game(gets.chomp)
      @board.display(@current_pos)
    when "h"
      display_help
      @board.display(@current_pos)
    when "q"
      abort("Giving up so soon?")
    when "\u0003"
      exit 0
    # when /^.$/
    #   puts "SINGLE CHAR HIT: #{c.inspect}"
    else
      puts "SOMETHING ELSE: #{c.inspect}"
    end
  end

  def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end

end

g = Minesweeper.new
g.run

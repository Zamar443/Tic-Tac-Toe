class Board
  def initialize
    # Represent the board as an array of 9 cells
    @grid = Array.new(9, ' ')
  end

  def display
    puts "\n"
    3.times do |i|
      row = @grid.slice(i * 3, 3).join(" | ")
      puts row
      puts "-" * 9 if i < 2
    end
    puts "\n"
  end

  def update(position, symbol)
    if valid_move?(position)
      @grid[position] = symbol
      true
    else
      false
    end
  end

  def valid_move?(position)
    position.between?(0, 8) && @grid[position] == ' '
  end

  def full?
    !@grid.include?(' ')
  end

  def grid
    @grid
  end

  def reset
    @grid = Array.new(9, ' ')
  end
end

class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

class Game
  def initialize
    @board = Board.new
    # Prompt the players for their names and symbols.
    print "Enter the name of the first player: "
    name1 = gets.chomp
    print "Enter the symbol for the first player (X or O): "
    symbol1 = gets.chomp.upcase

    print "Enter the name of the second player: "
    name2 = gets.chomp
    print "Enter the symbol for the second player (X or O): "
    symbol2 = gets.chomp.upcase

    @players = [Player.new(name1, symbol1), Player.new(name2, symbol2)]
    @current_player_index = 0
  end

  def switch_player
    @current_player_index = 1 - @current_player_index
  end

  def check_winner
    b = @board.grid
    win_combinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], # rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], # columns
      [0, 4, 8], [2, 4, 6]             # diagonals
    ]
    win_combinations.any? do |combo|
      a, b1, c = combo
      b[a] == b[b1] && b[b1] == b[c] && b[a] != ' '
    end
  end

  def play
    loop do
      @board.display
      current_player = @players[@current_player_index]
      print "#{current_player.name} (#{current_player.symbol}), enter your move (0-8): "
      input = gets.chomp

      # Validate that the input is an integer.
      begin
        move = Integer(input)
      rescue ArgumentError
        puts "Invalid input! Please enter a number between 0 and 8."
        next
      end

      unless @board.valid_move?(move)
        puts "Invalid move! Try again."
        next
      end

      @board.update(move, current_player.symbol)

      # Check for a winning move.
      if check_winner
        @board.display
        puts "Congratulations, #{current_player.name}! You have won the game!"
        break
      end

      # Check for a draw.
      if @board.full?
        @board.display
        puts "It's a draw!"
        break
      end

      switch_player
    end

    puts "Game over."
  end
end

# Run the game if this file is executed directly.
if __FILE__ == $0
  game = Game.new
  game.play
end

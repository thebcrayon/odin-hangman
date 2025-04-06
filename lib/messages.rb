# frozen_string_literal: true

# Module: Messages
# Handles all the text prompts and messages for the Hangman game.
# It asks for player names, prompts for moves, and shows error messages
# when something goes wrong. Just keeps the game talking to the players.
module Messages
  class << self
    def attempts_left(num = 6)
      "Attempts Left: #{num}"
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

    def error_invalid_entry
      puts 'Invalid input, please try again:'
      gets.chomp
    end

    def incorrect_guesses(num = 6)
      "Misses: #{num}"
    end

    def print_game_info(board_array)
      game_info = [game_title, progress(board_array), attempts_left, incorrect_guesses]
      longest_line = game_info.max_by(&:length).size
      game_info.each_with_index do |info, index|
        puts row_decoration_plain(longest_line)
        puts "| #{info.ljust(longest_line)} |"
        puts row_decoration_plain(longest_line) if index == game_info.size - 1
      end
    end

    def print_new_line
      puts ''
    end

    def prompt_continue
      puts 'Press any key to continue:'
      gets.chomp
    end

    def prompt_enter_guess
      puts 'Enter a code:'
      gets.chomp
    end

    def prompt_guess_quantity
      puts 'Who many tries to guess the code?'
      gets.chomp
    end

    def prompt_move(player_name, gameboard)
      puts "Player Turn: #{player_name}\nPlease Select an open space to play:"
      print_current_board(gameboard)
      gets.chomp
    end

    def prompt_player_name
      puts 'Enter Player Name:'
      gets.chomp
    end

    def prompt_total_guesses
      puts 'How many guesses would you like?'
      gets.chomp
    end

    private

    def game_title
      'Welcome to Hangman!'
    end

    def progress(board_array)
      "Word: #{board_array.map { |cell| cell.nil? ? '_' : cell }.join(' ')}"
    end

    def row_decoration
      spaces = [4, 9, 9]
      "+#{spaces.map { |w| '-' * w }.join('+')}+"
    end

    def row_decoration_plain(num)
      "+#{'-' * (num + 2)}+"
    end
  end
end
